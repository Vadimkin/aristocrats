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

    func isLive() -> Bool {
        return self.artist == "Аристократи"
    }
}

struct AristocratsPlaylistTrack: Decodable, Equatable, Hashable {
    var artist: String = "Аристократи"
    var song: String = " "

    var time: String
}
