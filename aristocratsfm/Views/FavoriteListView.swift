//
//  FavoriteListView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct FavoriteListView: View {
    let dataController = DataController.shared
    
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        entity: Favorite.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Favorite.createdAt, ascending: false)
        ]
    ) var favorites: FetchedResults<Favorite>
    
    var body: some View {
        let favoritesString = NSLocalizedString("favorites", comment: "Favorites")
        let noFavoritesString = NSLocalizedString("noFavoritesPlaceholder", comment: "Favorite tracks will be displayed here")

        return NavigationView {
            if (favorites.count > 0) {
                List {
                    ForEach(favorites, id: \.self) { (favorite) in
                        FavoriteTrack(favorite: favorite)
                    }.onDelete(perform: { indexSet in
                        self.delete(at: indexSet)
                    })
                }
                .navigationBarItems(trailing: EditButton())
                .navigationBarTitle(favoritesString)
            } else {
                VStack(alignment: .center) {
                    LottieView(name: "TeaCup")
                        .frame(maxHeight: 300, alignment: .center)
                    Text(noFavoritesString)
                        .font(.title3)
                        .lineSpacing(9)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 60)
                        .padding(.top, 20)
                }
                .navigationBarTitle(favoritesString)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        let favorite = favorites[offsets.first!]
        try? dataController.delete(favorite: favorite)
    }
}

struct FavoriteListView_Previews: PreviewProvider {

    static var previews: some View {
        let dataController = DataController.shared

        return FavoriteListView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
