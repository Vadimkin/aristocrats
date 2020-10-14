//
//  TrackMetadataView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI
import Combine

struct TrackMetadataView: View {
    var stream: String? = Streams.Main.Name
    
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .init()

    var body: some View {
        let playback = nowPlaying.playback
        switch playback {
        case .nothing:
            Text("¯\\_(ツ)_/¯") // Placeholder ?
        case let .playing(track, artwork):
            VStack(alignment: .center) {
                ImageView(withURL: artwork?.images.first?.image ?? "")
                    // Sorry, removed styles here just for testing
                    .shadow(
                        color: Color(red: 0.51, green: 0.51, blue: 0.51, opacity: 0.1),
                        radius: 4,
                        x:0,
                        y:2
                    )

                Text(track.song)
                    .font(Font.system(size: 20, weight: .medium, design: .default))
                Text(track.artist)
                                .font(Font.system(size: 17, weight: .light, design: .default))
                                .padding(.top, 11)
                                .foregroundColor(Design.Primary.LightGray)
                                .multilineTextAlignment(.center)
                        }.padding()          .foregroundColor(Design.Primary.DarkGray)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
        }
    }
}

struct TrackMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMetadataView()
    }
}
