//
//  NowPlayingParserDelegate.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 13.10.2020.
//

import Foundation

final class PlaylistParserDelegate: NSObject, XMLParserDelegate {
    static let shared = PlaylistParserDelegate()

    private var error: Error?

    private var playlist: [AristocratsTrack]? = []
    var newTrack: AristocratsTrack?

    enum State { case none, artist, song, time }
    var state: State = .none

    func build() throws -> [AristocratsTrack]? {
        return self.playlist
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        self.playlist = []
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        switch elementName {
        case "track":
            self.newTrack = AristocratsTrack()
            self.state = .none
        case "artist":
            self.state = .artist
        case "song":
            self.state = .song
        case "time":
            self.state = .time
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let _ = self.newTrack else { return }
        switch self.state {
        case .artist:
            self.newTrack!.artist = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case .song:
            self.newTrack!.song = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case .time:
            self.newTrack!.time = string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if let newTrack = self.newTrack, elementName == "track" {
            self.playlist!.append(newTrack)
            self.newTrack = nil
        }
        self.state = .none
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.playlist = []
    }
}
