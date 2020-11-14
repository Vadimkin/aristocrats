//
//  StreamType.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.10.2020.
//
import Foundation

struct StreamType {
    var name: String = ""
    var URI: String = ""
    var nowPlayingTrackURI: URL // URI to API service with current track
    var playlistURI: URL // Last tracks
}
