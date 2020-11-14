//
//  PreviewProvider.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 14.11.2020.
//

import Foundation
import SwiftUI
import CoreData

extension PreviewProvider {
    static func createFavoriteTrack(track: AristocratsTrack) -> Favorite {
        let context = DataController.shared.context

        let likedTrack = Favorite.init(context: context)
        likedTrack.artist = track.artist
        likedTrack.song = track.song
        likedTrack.createdAt = Date()
        likedTrack.uuid = UUID()
        return likedTrack
    }
}
