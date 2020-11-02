//
//  Publishers.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation
import Combine

extension Publishers {
    static func nowPlaying() -> AnyPublisher<NowPlayingTrack?, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Streams.Main.NowPlayingTrackURI)
            .tryMap { response -> NowPlayingTrack? in
                let delegate: NowPlayingParserDelegate = .shared

                let parser = XMLParser(data: response.data)
                parser.delegate = delegate

                return parser.parse() ? try delegate.build() : nil
            }
            .eraseToAnyPublisher()
    }

    static func musicBrainzPublisher(
        artist: String,
        song: String
    ) -> AnyPublisher<MusicBrainz, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL.Music.musicBrainz(artist: artist, song: song))
            .map { $0.data }
            .decode(type: MusicBrainz.self, decoder: JSONDecoder.shared)
            .eraseToAnyPublisher()
    }

    static func coverArtArchivePublisher(id: String) -> AnyPublisher<CoverArt, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL.Music.coverArt(id: id))
            .map { $0.data }
            .decode(type: CoverArt.self, decoder: JSONDecoder.shared)
            .eraseToAnyPublisher()
    }
}
