//
//  AppConstants.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import Foundation
import SwiftUI
import Combine

struct Design {
    struct Primary {
        static let Base = Color(red: 0.65, green: 0.03, blue: 0.24)
        static let Gray = Color(red: 0.6, green: 0.6, blue: 0.6)
        static let DarkGray = Color(red: 0.11, green: 0.11, blue: 0.11)
        static let LightGray = Color(red: 0.11, green: 0.11, blue: 0.11, opacity: 0.5)
    }
}

struct Streams {
    static let Main = StreamType(Name: "Main", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-aristocrats8.xml")!)
    
    static let Music = StreamType(Name: "Music", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!)

    static let Jazz = StreamType(Name: "Jazz", URI: "http://air.aristocrats.fm:8000/live2", NowPlayingTrackURI: URL(string: "https://aristocrats.fm/service/nowplaying-amusic8.xml")!)
}

var SupportedStreams = [Streams.Main]

let MusicbrainzAPIHost = "https://musicbrainz.org/"
let CoverArtAPIHost = "https://coverartarchive.org/"
