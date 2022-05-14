//
//  Publishers.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation
import Combine

extension Publishers {
    static func nowPlaying() -> AnyPublisher<AristocratsTrack?, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Streams.NowPlayingTrackURL)
            .tryMap { response -> AristocratsTrack? in
                let delegate: NowPlayingParserDelegate = .shared

                let parser = XMLParser(data: response.data)
                parser.delegate = delegate

                return parser.parse() ? try delegate.build() : nil
            }
            .eraseToAnyPublisher()
    }

    static func playlistPublisher() -> AnyPublisher<[AristocratsTrack]?, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Streams.PlaylistURL)
            .tryMap { response -> [AristocratsTrack]? in
                let delegate: PlaylistParserDelegate = .shared

                let parser = XMLParser(data: response.data)
                parser.delegate = delegate

                return parser.parse() ? try delegate.build() : nil
            }
            .eraseToAnyPublisher()
    }
}
