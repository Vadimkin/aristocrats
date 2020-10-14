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
    private var error: Error?
    
    func build() throws -> NowPlayingTrack? {
        if let artist = artist, let song = song {
            return NowPlayingTrack(artist: artist, song: song)
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
        attributes attributeDict: [String : String] = [:]
    ) {
        switch elementName {
        case "artist":
            artist = attributeDict["title"]

        case "song":
            song = attributeDict["title"]

        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        artist = nil
        song = nil
    }
}
