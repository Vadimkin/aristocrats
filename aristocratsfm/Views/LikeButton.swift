//
//  LikeButton.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 05.11.2020.
//

import SwiftUI
import Combine
import CoreData

struct LikeButton: View {
    var track: AristocratsTrack

    @Environment(\.managedObjectContext) private var moc
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest var favorites: FetchedResults<Favorite>

    var favorite: Favorite? { favorites.first }

    init(track: AristocratsTrack) {
        self.track = track
        self._favorites = FetchRequest(
            entity: Favorite.entity(),
            sortDescriptors: [],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "artist = %@ ", track.artist),
                NSPredicate(format: "song = %@ ", track.song)
            ])
        )
    }

    var body: some View {
        ZStack {
            if let favorite = favorite {
                LikeAnimatedButton()
                    .scaledToFit()
                    .onTapGesture(perform: {
                        removeFromFavorite(favorite)
                    })
            } else {
                Button(action: addToFavorites) {
                    Image(systemName: "suit.heart")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.6)
                        .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.Gray)
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                }
            }
        }.frame(maxHeight: 70, alignment: .leading)
    }

    private func addToFavorites() {
        let newFavorite = Favorite(context: moc)

        newFavorite.uuid = UUID()
        newFavorite.artist = track.artist
        newFavorite.song = track.song
        newFavorite.created_at = Date()

        save()
        
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    private func removeFromFavorite(_ favorite: Favorite) {
        moc.delete(favorite)

        save()
    }

    private func save() {
        do {
            try moc.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(track: AristocratsTrack(artist: "Hey", song: "Hey"))
    }
}
