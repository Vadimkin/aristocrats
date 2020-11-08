//
//  PlaylistSingleTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistSingleTrack: View {
    let track: AristocratsTrack
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(track.artist)
                        .foregroundColor(Color.white)
                        .font(.title2)
                    Text(track.song)
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()
                if (track.time != nil) {
                    Text(track.time!)
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .fontWeight(.light)
                }
                
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.horizontal)
            .listRowBackground(Color(UIColor(named: "BaseColor")!))
    }
}

struct PlaylistSingleTrack_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSingleTrack(track: AristocratsTrack(artist: "Hey", song: "Hop", time: "10:10"))
            .background(Color(UIColor(named: "BaseColor")!))
    }
}
