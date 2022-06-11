//
//  FavoriteTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct FavoriteTrack: View {
    let favorite: Favorite

    let timer = Timer.publish(
        every: 1, // second
        on: .main,
        in: .common
    )
        .autoconnect()
        .prepend(Date())

    let formatter = RelativeDateTimeFormatter()

    @State var formattedTime: String = ""

    init(favorite: Favorite) {
        self.favorite = favorite

        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
    }

    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(favorite.song ?? "")
                        .font(.title3)
                    Text(favorite.artist ?? "")
                        .font(.headline)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()

                if favorite.createdAt != nil {
                    Text(formattedTime)
                        .onReceive(timer) { (_) in
                            if favorite.createdAt != nil {
                                self.formattedTime = formatter.string(for: favorite.createdAt)!
                            }
                        }
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
