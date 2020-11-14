//
//  NowPlayingParserDelegate.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation

final class NowPlayingParserDelegate: NSObject, XMLParserDelegate {
    static let shared = NowPlayingParserDelegate()

    private var artist: String?
    private var song: String?
    private var isLive: Bool?

    private var error: Error?

    func build() throws -> AristocratsTrack? {
        if let artist = artist, let song = song, let isLive = isLive {
            return AristocratsTrack(artist: artist, song: song, isLive: isLive)
        } else if let error = error {
            throw error
        }

        return nil
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        switch elementName {
        case "artist":
            if attributeDict["title"] != "" {
                artist = attributeDict["title"]
            } else {
                artist = NSLocalizedString("live", comment: "Live Stream")
                isLive = true
            }

        case "song":
            if attributeDict["title"] != "" {
                song = attributeDict["title"]
            } else {
                song = NSLocalizedString("aristocrats", comment: "Aristocrats")
            }

        default:
            break
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        artist = nil
        song = nil
        isLive = false
    }
}
