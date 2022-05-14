//
//  URL.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation

extension URL {
    enum Music {
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
    }
}
