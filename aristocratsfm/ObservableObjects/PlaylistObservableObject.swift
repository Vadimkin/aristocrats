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

    private var cancellable: Cancellable?
    
    init() {
        self.cancellable = Deferred { Just(Date()) }
            .append(Timer.publish(every: 10, on: .main, in: .common).autoconnect())
            .flatMap { _ in Publishers.playlistPublisher() }
            .removeDuplicates()
            .wrapInResult()
            .receive(on: DispatchQueue.main)
            .sink { result in
                do {
                    let playback = try result.get()
                    self.playlist = playback
                } catch {
                    debugPrint(error)
                }
            }
    }
}
