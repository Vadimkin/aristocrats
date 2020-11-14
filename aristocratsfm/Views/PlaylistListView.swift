//
//  PlaylistListView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistListView: View {
    @ObservedObject var playlist: PlaylistObservableObject = .shared
    
    var body: some View {
        LazyVStack {
            if (playlist.playlist != nil) {
                ForEach(playlist.playlist!, id: \.self) { track in
                    PlaylistTrackView(track: track)
                    Divider()
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 30)
        .background(Color(UIColor(named: "BaseColor")!))
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        // FIXME Fix it someday with mocked @ObservedObject
        return PlaylistListView()
    }
}
