//
//  StreamType.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.10.2020.
//
import Foundation

struct StreamType {
    var Name: String = ""
    var URI: String = ""
    var NowPlayingTrackURI: URL // URI to API service with current track
    var PlaylistURI: URL // Last tracks (usualy ~10)
}
