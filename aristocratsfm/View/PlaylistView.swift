//
//  PlaylistView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistView: View {
    var body: some View {
        ZStack {
            Design.Primary.Base.edgesIgnoringSafeArea(.all)
            NavigationView {
                List {
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                    PlaylistSingleTrack()
                }.navigationBarTitle(Text("Плейлист"))
            }
        }
    }
}


struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
        
    }
}
