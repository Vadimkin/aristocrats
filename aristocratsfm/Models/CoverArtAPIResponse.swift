//
//  CoverArtResponse.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 08.10.2020.
//

import Foundation
import ObjectMapper

class CoverArtImage: Mappable {
    var id: String = ""
    var image: String? = nil
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
    }
}

class CoverArtReleaseAPIResponse: Mappable {
    var release: String? = nil
    var images: [CoverArtImage] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        release <- map["release"]
        images <- map["images"]
    }
}
