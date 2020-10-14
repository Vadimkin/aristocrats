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

let timerInterval = 5.0;

let cancellable = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .flatMap { _ in Publishers.nowPlaying() }
    .removeDuplicates()
    .flatMap { nowPlaying -> AnyPublisher<(NowPlayingTrack, MusicBrainz?)?, Error> in
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
            .map {
                (nowPlayingMusicBrainz.0, $0)
            }
            .eraseToAnyPublisher()
    }
    .map { nowPlayingCoverArt in
        nowPlayingCoverArt.map {
            Playback.playing($0.0, $0.1)
        } ?? Playback.nothing
    }
    .wrapInResult()
    .sink { result in
        do {
            switch try result.get() {
            case .nothing:
                print("Nothing playing right now.")
            case let .playing(playing, coverArt):
                print("Now playing: \(playing.song) - \(playing.song) [\(coverArt?.images.first?.image ?? "no cover")]")
            }
        } catch {
            debugPrint(error)
        }
    }
