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
    var time: String?
}