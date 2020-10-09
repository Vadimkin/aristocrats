//
//  PlaylistSingleTrack.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 04.10.2020.
//

import SwiftUI

struct PlaylistSingleTrack: View {
    let title = "Once I Saw the River Clean"
    let artist = "Morrissey"
    let time = "10:21"
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(artist)
                        .foregroundColor(Color.white)
                        .font(.title)
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .padding(.top, 3)
                }
                Spacer()
                Text(time)
                    .foregroundColor(Color.white)
                    .font(.title)
                    .fontWeight(.light)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        .listRowBackground(Design.Primary.Base)
    }
}

struct PlaylistSingleTrack_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSingleTrack()
    }
}
