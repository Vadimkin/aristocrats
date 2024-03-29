//
//  PlaylistObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.11.2020.
//

import Foundation
import Combine

class PlaylistObservableObject: ObservableObject {
    static let shared = PlaylistObservableObject.init()

    @Published var playlist: [AristocratsPlaylistTrack]?
    @Published var cancellable: Cancellable?

    init() {
        initializeTimer()
    }

    func initializeTimer() {
        self.cancellable = Deferred { Just(Date()) }
            // To not have two timers at the same time
            .append(Timer.publish(every: 7, tolerance: 1, on: .main, in: .common).autoconnect())
            .flatMap { _ in Publishers.playlistPublisher().replaceErrorWithNil(Error.self) }
            // TODO To not sink when we already know that error is here?
            .removeDuplicates()
            .wrapInResult()
            .receive(on: DispatchQueue.main)
            .sink { result in
                do {
                    let playback = try result.get()
                    if playback != nil {
                        self.playlist = playback
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
}
