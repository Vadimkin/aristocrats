//
//  CoverArt.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 08.10.2020.
//

import Foundation

struct CoverArt: Decodable, Equatable {
    let images: [Image]

     struct Image: Decodable, Equatable {
        let image: String
        let thumbnails: CoverArtThumbnail

        struct CoverArtThumbnail: Decodable, Equatable {
            let large: String
        }
    }
}
