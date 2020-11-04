//
//  PlaylistObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.11.2020.
//

import Foundation
import Combine
import Alamofire
import SwiftyXMLParser

class PlaylistObservableObject: ObservableObject {
    static let shared = PlaylistObservableObject.init()

    @Published var playlist: [NowPlayingTrack]?

    @Published var cancellable: Cancellable?
    
    init() {
        initializeTimer()
    }
    
    func initializeTimer() {
        self.cancellable = Deferred { Just(Date()) }
            .append(Timer.publish(every: 5, on: .main, in: .common).autoconnect())
            .flatMap { _ in Publishers.playlistPublisher().replaceErrorWithNil(Error.self) }
            .removeDuplicates()
            .wrapInResult()
            .receive(on: DispatchQueue.main)
            .sink { result in
                do {
                    let playback = try result.get()
                    if (playback != nil) {
                        self.playlist = playback as? [NowPlayingTrack]
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
    
    func stopTimer() {
        self.cancellable?.cancel()
    }
}
