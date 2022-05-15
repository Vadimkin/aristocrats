//
//  LikeButtonView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 05.11.2020.
//

import SwiftUI
import Combine
import CoreData

struct LikeButtonView: View {
    var track: AristocratsTrack
    let dataController: DataController = DataController.shared

    @FetchRequest var favorites: FetchedResults<Favorite>
    @State var animateLoading: Bool = false

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
                LikeButtonLottieView(animated: animateLoading)
                    .scaleEffect(1/0.666) // Magic coeficient to keep the same size for image and button
                    .scaledToFit()
                    .padding(.leading, -1)
                    .onTapGesture(perform: {
                        removeFromFavorite(favorite)
                    })
            } else {
                Button(action: addToFavorites) {
                    Image(systemName: "suit.heart")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1)
                        .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                }
            }
        }
        .frame(maxHeight: 50, alignment: .leading)
        .padding(.leading, -10)
    }

    private func addToFavorites() {
        self.animateLoading = true

        try? dataController.insertFavoriteTrack(track: track)

        FirebaseAnalytics.logTrackLike(track: track, source: FirebaseAnalyticsTrackSource.mainScreen)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    private func removeFromFavorite(_ favorite: Favorite) {
        self.animateLoading = true

        try? dataController.delete(favorite: favorite)
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController.shared

        let track = AristocratsTrack(artist: "Hey", song: "Hey")
        _ = self.createFavoriteTrack(track: track)

        return LikeButtonView(track: track)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
