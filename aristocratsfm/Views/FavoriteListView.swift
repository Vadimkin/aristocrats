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
        NavigationView {
            if (favorites.count > 0) {
                List {
                    ForEach(favorites, id: \.self) { (favorite) in
                        FavoriteTrack(favorite: favorite)
                    }.onDelete(perform: { indexSet in
                        self.delete(at: indexSet)
                    })
                }
                .navigationBarTitle("Обране")
                .navigationBarItems(leading: EditButton())
            } else {
                    VStack(alignment: .center) {
                        LottieView(name: "TeaCup")
                            .frame(maxHeight: 300, alignment: .center)
                        Text("Тут з'являться треки, які ви додасте до обраного")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                    }
                    .navigationBarTitle("Обране")
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
        FavoriteListView()
    }
}