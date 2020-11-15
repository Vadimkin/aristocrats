//
//  FavoriteTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct FavoriteTrack: View {
    let favorite: Favorite

    let formatter = RelativeDateTimeFormatter()

    init(favorite: Favorite) {
        self.favorite = favorite

        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
    }

    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(favorite.artist ?? "")
                        .font(.title3)
                    Text(favorite.song ?? "")
                        .font(.headline)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()

                if favorite.createdAt != nil {
                    Text(formatter.string(for: favorite.createdAt)!)
                }

            }
            .padding(.vertical, 10)
    }
}

struct FavoriteTrack_Previews: PreviewProvider {
    static var previews: some View {
        let track = AristocratsTrack(artist: "The xx", song: "Together")
        let favorite = self.createFavoriteTrack(track: track)

        FavoriteTrack(favorite: favorite)
            .padding()
    }
}
