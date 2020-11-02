//
//  MusicBrainzAPIResponse.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.10.2020.
//

import Foundation

 struct MusicBrainz: Decodable, Equatable {
    let recordings: [Recordings]

     struct Recordings: Decodable, Equatable {
        let id: String
        let releases: [Releases]

         struct Releases: Decodable, Equatable {
            let id: String
        }
    }
}
