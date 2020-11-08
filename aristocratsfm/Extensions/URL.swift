//
//  MusicBrainz.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation

extension URL {
    enum Music {
        static let nowPlaying = Streams.Main.NowPlayingTrackURI

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
        
        static func songwhip(artist: String, song: String) -> URL {
            // TODO Is not used yet, expected to use for sharing
            var components = URLComponents(string: "https://songwhip.com/api/")!
            components.queryItems = [
                .init(name: "q", value: "\(artist) \(song)"),
                .init(name: "country", value: "UA"),
                .init(name: "limit", value: "1")
            ]
            return components.url!
        }

        static func coverArt(id: String) -> URL {
            URL(string: "https://coverartarchive.org/release/\(id)")!
        }
    }
    
    static func alwaysSecuredURL(insecuredURL: URL) -> URL {
        var comps = URLComponents(url: insecuredURL, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!
        return https
    }
}
