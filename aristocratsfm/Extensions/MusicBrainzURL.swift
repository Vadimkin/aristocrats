//
//  MusicBrainz.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation

//extension URL {
//    enum Music {
//        static func musicBrainz(artist: String, song: String) -> URL {
//            var components = URLComponents(string: "https://musicbrainz.org/ws/2/recording")!
//            components.queryItems = [
//                .init(name: "query", value: "artistname:\"\(artist)\" AND recording:\"\(song)\""),
//                .init(name: "inc", value: "releases"),
//                .init(name: "fmt", value: "json"),
//                .init(name: "limit", value: "1")
//            ]
//            return components.url!
//        }
//
//        static func coverArt(id: String) -> URL {
//            URL(string: "https://coverartarchive.org/release/\(id)")!
//        }
//    }
//}

extension URL {
    enum Music {
        static let nowPlaying = URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!

        static func musicBrainz(artist: String, song: String) -> URL {
            var components = URLComponents(string: "https://musicbrainz.org/ws/2/recording")!
            components.queryItems = [
                .init(name: "query", value: "artistname:\"\(artist)\" AND recording:\"\(song)\""),
                .init(name: "inc", value: "releases"),
                .init(name: "fmt", value: "json"),
                .init(name: "limit", value: "1")
            ]
            return components.url!
        }

        static func coverArt(id: String) -> URL {
            URL(string: "https://coverartarchive.org/release/\(id)")!
        }
    }
}
