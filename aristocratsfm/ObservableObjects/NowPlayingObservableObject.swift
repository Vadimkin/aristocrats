//
//  NowPlayingObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.10.2020.
//

import Foundation
import Combine
import Alamofire
import SwiftyXMLParser

enum Playback: Equatable {
    case nothing
    case playing(_ playing: NowPlayingTrack, _ coverArt: CoverArt?)
}

class NowPlayingObservableObject: ObservableObject {
    static let shared = NowPlayingObservableObject.init()

    @Published var playback: Playback = .nothing

    private var cancellable: Cancellable?
    
    init() {
        self.cancellable = Deferred { Just(Date()) }
            // FIXME Do not fail when internet is down
            .append(Timer.publish(every: 5, on: .main, in: .common).autoconnect())
            .flatMap { _ in Publishers.nowPlaying().replaceErrorWithNil(Error.self) }
            .removeDuplicates()
            .flatMap { nowPlaying -> AnyPublisher<(NowPlayingTrack, MusicBrainz?)?, Error> in
                guard let nowPlaying = nowPlaying else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                if let nowPlaying = nowPlaying {
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
            .flatMap { (nowPlayingMusicBrainz) -> AnyPublisher<(NowPlayingTrack, CoverArt?)?, Error> in
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
                        print("Now playing: \(playing.artist) - \(playing.song) [\(coverArt?.images.first?.thumbnails.large ?? "no cover")]")
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
}
