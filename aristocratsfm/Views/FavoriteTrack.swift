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
                        .font(.title2)
                    Text(favorite.song ?? "")
                        .font(.title3)
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
