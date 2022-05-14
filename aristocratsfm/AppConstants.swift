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
    static let Low = StreamType(
        name: "Low",
        URI: URL(string: "http://air.aristocrats.fm:8000/live2-64")!
    )

    static let Normal = StreamType(
        name: "Normal",
        URI: URL(string: "http://air.aristocrats.fm:8000/live2")!
    )

    static let High = StreamType(
        name: "High",
        URI: URL(string: "http://air.aristocrats.fm:8000/live2-320")!
    )

    static func byName(name: String) -> StreamType {
        switch name {
        case Streams.Low.name:
            return Streams.Low
        case Streams.Normal.name:
            return Streams.Normal
        case Streams.High.name:
            return Streams.High
        default:
            return Streams.Normal
        }
    }

    static let NowPlayingTrackURL = URL(string: "https://vadimklimenko.com/arstcr/current_track.json")!
    static let PlaylistURL = URL(string: "https://vadimklimenko.com/arstcr/last10.json")!

    static let List = [Streams.Low, Streams.Normal, Streams.High]
}
