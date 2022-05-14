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
    case playing(_ playing: AristocratsTrack)
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
            .flatMap { nowPlaying -> AnyPublisher<(AristocratsTrack)?, Error> in
                if let nowPlaying = nowPlaying {
                    return Result.Publisher((nowPlaying))
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .map { nowPlaying in
                nowPlaying.map {
                    return Playback.playing($0)
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
                    case let .playing(playing):
                        print("Now playing: \(playing.artist) - \(playing.song) " +
                              "[\(playing.artwork)]")
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
}
