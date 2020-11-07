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
    var track: AristocratsTrack?

    @Environment(\.managedObjectContext) private var moc
    @Environment(\.colorScheme) var colorScheme
    
    @State var isFavorited: Bool = false

    func addToFavorites(track: AristocratsTrack) -> Bool {
        let newFavorite = Favorite(context: moc)

        newFavorite.uuid = UUID()
        newFavorite.artist = track.artist
        newFavorite.song = track.song
        newFavorite.created_at = Date()

        do {
            try moc.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return true
    }

    var body: some View {
        ZStack{
            Button(action: {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)

                // TODO Add/remove from favorites
                isFavorited.toggle()
            }) {
                if (!isFavorited) {
                    Image(systemName: isFavorited ? "suit.heart.fill" : "suit.heart")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.6)
                        .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.Gray)
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                }
            }
            if (isFavorited) {
                    LikeAnimatedButton()
                        .scaledToFit()
                        .onTapGesture {
                            isFavorited.toggle()
                        }
            }
        }.frame(maxHeight: 70, alignment: .leading)
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(track: AristocratsTrack(artist: "Hey", song: "Hey"))
    }
}
