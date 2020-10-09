//
//  MusicBrainzAPIResponse.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.10.2020.
//

import Foundation
import ObjectMapper


class MusicBrainzRelease: Mappable {
    var id: String? = nil
    var title: String? = nil
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
    }
}

class MusicBrainzRecordingRelation: Mappable {
    var releases: [MusicBrainzRelease] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        releases <- map["releases"]
    }
}

class MusicBrainzArtworkAPIResponse: Mappable {
    var count: Int = 0
    var recordings: [MusicBrainzRecordingRelation] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        recordings <- map["recordings"]
    }
}
