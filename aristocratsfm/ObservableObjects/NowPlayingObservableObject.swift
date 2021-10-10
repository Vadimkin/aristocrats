//
//  NowPlayingObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.10.2020.
//

import Foundation
import Combine

enum Playback: Equatable {
    case nothing
    case playing(_ playing: AristocratsTrack, _ coverArt: CoverArt?)
}

class NowPlayingObservableObject: ObservableObject {
    static let shared = NowPlayingObservableObject.init()

    @Published var playback: Playback = .nothing

    private var cancellable: Cancellable?

    init() {
        let timer = Timer.publish(every: 15, tolerance: 0.5, on: .main, in: .common)

        self.cancellable = Deferred { Just(Date()) }
            .append(timer.autoconnect())
            .flatMap { _ in Publishers.nowPlaying().replaceErrorWithNil(Error.self) }
            .removeDuplicates()
            .flatMap { nowPlaying -> AnyPublisher<(AristocratsTrack, MusicBrainz?)?, Error> in
                guard let nowPlaying = nowPlaying else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                if let nowPlaying = nowPlaying {
                    if UserDefaults.standard.bool(forKey: "ArtworkEnabled") == false {
                        // User refuses to load any Artworks
                        return Result.Publisher((nowPlaying, nil))
                            .eraseToAnyPublisher()
                    }

                    return Publishers.musicBrainzPublisher(
                        artist: nowPlaying.artist,
                        song: nowPlaying.song
                    )
                    .replaceErrorWithNil(Error.self)
                    .map {
                        (nowPlaying, $0)
                    }
                    .eraseToAnyPublisher()
                }

                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .flatMap { (nowPlayingMusicBrainz) -> AnyPublisher<(AristocratsTrack, CoverArt?)?, Error> in
                guard let nowPlayingMusicBrainz = nowPlayingMusicBrainz else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                guard
                    let musicBrainz = nowPlayingMusicBrainz.1,
                    let releaseId = musicBrainz.recordings.first?.releases.first?.id
                else {
                    return Just((nowPlayingMusicBrainz.0, nil))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                return Publishers.coverArtArchivePublisher(id: releaseId)
                    .replaceErrorWithNil(Error.self)
                    .map { (nowPlayingMusicBrainz.0, $0) }
                    .eraseToAnyPublisher()
            }
            .map { nowPlayingCoverArt in
                nowPlayingCoverArt.map {
                    return Playback.playing($0.0, $0.1)
                } ?? Playback.nothing
            }
            .wrapInResult()
            .receive(on: DispatchQueue.main)
            .sink { result in
                do {
                    let playback = try result.get()
                    self.playback = playback
                    switch playback {
                    case .nothing:
                        print("Nothing is playing right now.")
                    case let .playing(playing, coverArt):
                        print("Now playing: \(playing.artist) - \(playing.song) " +
                              "[\(coverArt?.images.first?.thumbnails.large ?? "no cover")]")
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
}
