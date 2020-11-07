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
        attributes attributeDict: [String : String] = [:]
    ) {
        switch elementName {
        case "artist":
            artist = attributeDict["title"] != "" ? attributeDict["title"] : "Прямий етер"
            isLive = true

        case "song":
            song = attributeDict["title"] != "" ? attributeDict["title"] : "Аристократи"

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
