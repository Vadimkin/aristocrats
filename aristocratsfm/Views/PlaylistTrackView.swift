//
//  PlaylistTrackView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistTrackView: View {
    let track: AristocratsTrack
    let dataController = DataController.shared

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

    private func addToFavorites() {
        try? dataController.insertFavoriteTrack(track: track)

        FirebaseAnalytics.logTrackLike(track: track, source: FirebaseAnalyticsTrackSource.playlist)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    private func removeFromFavorite(_ favorite: Favorite) {
        try? dataController.delete(favorite: favorite)
    }

    func getHearthColor() -> Color {
        return Color.white
    }

    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(track.song)
                        .foregroundColor(Color.white)
                        .font(.headline)
                    Text(track.artist)
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()
                if track.time != nil {
                    Text(track.time!)
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                Button(action: {
                    if favorite != nil {
                        removeFromFavorite(self.favorite!)
                    } else {
                        addToFavorites()
                    }
                }) {
                    Image(systemName: (favorite != nil) ? "suit.heart.fill" : "suit.heart")
                        .font(.title)
                        .foregroundColor(getHearthColor())
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                }

            }
            .padding(.vertical, 7)
            .padding(.horizontal)
            .listRowBackground(Color(UIColor(named: "BaseColor")!))
    }
}

struct PlaylistSingleTrack_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController.shared

        PlaylistTrackView(track: AristocratsTrack(artist: "Hey", song: "Hop", time: "10:10"))
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .background(Color(UIColor(named: "BaseColor")!))
    }
}
