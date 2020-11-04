//
//  PlaylistView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var playlist: PlaylistObservableObject = .shared
    
    var body: some View {
        LazyVStack {
            if (playlist.playlist != nil) {
                ForEach(playlist.playlist!, id: \.self) { track in
                    PlaylistSingleTrack(track: track)
                    Divider()
                }
            }
        }
        .padding(.bottom, 30)
        .background(Design.Primary.Base)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            playlist.stopTimer()
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            playlist.initializeTimer()
        }
    }
}


struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
