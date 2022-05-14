//
//  ArtistocratsTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.10.2020.
//

import Foundation
import Combine

struct AristocratsTrack: Decodable, Equatable, Hashable {
    var artist: String = "Аристократи"
    var song: String = " "
    var artwork: String = ""

    var time: String? // Is empty when this track is for playlist, usually in format HH:MM

    var isLive: Bool = false // Live stream from studio
}
