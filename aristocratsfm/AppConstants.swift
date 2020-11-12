//
//  AppConstants.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import Foundation
import SwiftUI
import Combine

struct Contacts {
    static let Email = "me@vadimklimenko.com"
    static let Telegram = "klimenko"
}

struct Design {
    struct Primary {
        static let DarkGray = Color(red: 0.11, green: 0.11, blue: 0.11)
        static let LightGray = Color(red: 0.055, green: 0.055, blue: 0.055)
    }
}

struct Streams {
    static let Main = StreamType(Name: "Main", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!, PlaylistURI: URL(string: "https://aristocrats.fm/last10.php?s=live")!)

//    static let Music = StreamType(Name: "Music", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!)
//
//    static let Jazz = StreamType(Name: "Jazz", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!)
}

