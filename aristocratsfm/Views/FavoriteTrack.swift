//
//  FavoriteTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct FavoriteTrack: View {
    let favorite: Favorite
    @State var isFavorited: Bool = true

    @Environment(\.managedObjectContext) private var moc
    @Environment(\.colorScheme) var colorScheme
    
    private func addToFavorites() {
        let newFavorite = Favorite(context: moc)

        newFavorite.uuid = UUID()
        newFavorite.artist = favorite.artist
        newFavorite.song = favorite.song
        newFavorite.created_at = favorite.created_at

        save()
        
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    private func removeFromFavorite() {
        moc.delete(favorite)

        save()
    }
    
    private func save() {
        try? moc.save()
    }
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(favorite.artist ?? "Deleted")
                        .font(.title2)
                    Text(favorite.song ?? "Deleted")
                        .font(.title3)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()
                Button(action: {
                    if (isFavorited) {
                        removeFromFavorite()
                    } else {
                        addToFavorites()
                    }
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "suit.heart.fill" : "suit.heart")
                        .font(.title)
                        .foregroundColor(isFavorited ? Color.red : (colorScheme == .dark ? Color.white : Color(UIColor(named: "BaseColor")!)))
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                }
            }
            .padding(.vertical, 10)
    }
}
