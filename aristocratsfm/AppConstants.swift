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
        nowPlayingTrackURI: URL(string: "https://vadimklimenko.com/arstcr/current_track.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=live")!
    )

    // Returns 404 :(
    static let Main320 = StreamType(
        name: "Main320",
        URI: URL(string: "http://air.aristocrats.fm:8000/live2-320")!,
        nowPlayingTrackURI: URL(string: "https://vadimklimenko.com/arstcr/current_track.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=live")!)

    static func byName(name: String) -> StreamType {
        switch name {
        case Streams.Main.name:
            return Streams.Main
        case Streams.Main320.name:
            return Streams.Main320
        default:
            return Streams.Main
        }
    }

    static let List = [Streams.Main, Streams.Main320]
}
