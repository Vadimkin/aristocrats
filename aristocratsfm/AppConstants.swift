//
//  AppConstants.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import Foundation
import SwiftUI
import Combine

enum Contacts {
    static let Email = "me@vadimklimenko.com"
    static let Telegram = "klimenko"

    static let TelegramPublicID = "radioaristocrats"
    static let TelegramChatID = "GC0sFhJGZwiUFR9yMvDWwA"
}

enum Design {
    enum Primary {
        static let DarkGray = Color(red: 0.11, green: 0.11, blue: 0.11)
        static let LightGray = Color(red: 0.055, green: 0.055, blue: 0.055)
    }
}

struct Streams {
    static let Main = StreamType(
        name: "Main",
        URI: URL(string: "http://air.aristocrats.fm:8000/live2")!,
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=live")!
    )

    // Returns 404 :(
    static let Music = StreamType(
        name: "Music",
        URI: URL(string: "http://air.aristocrats.fm:8000/amusic-128")!,
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=music")!)

    // Returns 404 :(
    static let Jazz = StreamType(
        name: "Jazz",
        URI: URL(string: "http://air.aristocrats.fm:8000/ajazz")!,
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-ajazz8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=jazz")!
    )

    static func byName(name: String) -> StreamType {
        switch name {
        case Streams.Main.name:
            return Streams.Main
        case Streams.Music.name:
            return Streams.Music
        case Streams.Jazz.name:
            return Streams.Jazz
        default:
            return Streams.Main
        }
    }

    static let List = [Streams.Main, Streams.Jazz, Streams.Music]
}
