//
//  Publishers.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation
import Combine

extension Publishers {
    static func nowPlaying() -> AnyPublisher<AristocratsTrack, Error> {
        return URLSession.shared
             .dataTaskPublisher(for: Streams.NowPlayingTrackURL)
             .map { $0.data }
             .decode(type: AristocratsTrack.self, decoder: JSONDecoder.shared)
             .eraseToAnyPublisher()
    }

    static func playlistPublisher() -> AnyPublisher<[AristocratsPlaylistTrack], Error> {
        return URLSession.shared
             .dataTaskPublisher(for: Streams.PlaylistURL)
             .map { $0.data }
             .decode(type: [AristocratsPlaylistTrack].self, decoder: JSONDecoder.shared)
             .eraseToAnyPublisher()
    }
}
