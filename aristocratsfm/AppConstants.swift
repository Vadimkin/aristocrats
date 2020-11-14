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
}

enum Design {
    enum Primary {
        static let DarkGray = Color(red: 0.11, green: 0.11, blue: 0.11)
        static let LightGray = Color(red: 0.055, green: 0.055, blue: 0.055)
    }
}

enum Streams {
    static let Main = StreamType(
        name: "Main",
        URI: "http://air.aristocrats.fm:8000/live2",
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=live")!
    )

    // Implement support for this stream
    static let Music = StreamType(
        name: "Music",
        URI: "http://air.aristocrats.fm:8000/live2",
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=music")!)

    // Implement support for this stream
    static let Jazz = StreamType(
        name: "Jazz",
        URI: "http://air.aristocrats.fm:8000/live2",
        nowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!,
        playlistURI: URL(string: "https://aristocrats.fm/last10.php?s=jazz")!
    )
}
