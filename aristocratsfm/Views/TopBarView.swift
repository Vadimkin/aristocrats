//
//  TopBarView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        entity: Favorite.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Favorite.created_at, ascending: false)
        ]
    ) var favorites: FetchedResults<Favorite>

    var body: some View {
        NavigationView {
            List {
                ForEach(favorites, id: \.self) { (favorite) in
                    FavoriteTrack(favorite: favorite)
                }
            }
            .navigationBarTitle("Обране")
        }
    }
}

struct TopBarView: View {
    @State var showingDetail = false

        var body: some View {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("❤️ Favorites")
            }.sheet(isPresented: $showingDetail) {
                DetailView()
            }
        }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
