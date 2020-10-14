//
//  TrackMetadataView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI
import Combine

struct TrackMetadataView: View {
    var artworkImage = Image("artwork-preview")
    var stream: String? = Streams.Main.Name
//    @ObservedObject var nowPlayingObservableObject: NowPlayingObservableObject = .shared

    var body: some View {
        VStack(alignment: .center) {
            artworkImage
                .resizable()
                .scaledToFit()
                .padding()
                .cornerRadius(30)
                .shadow(
                    color: Color(red: 0.51, green: 0.51, blue: 0.51, opacity: 0.1),
                    radius: 4,
                    x:0,
                    y:2
                )

//            Text(self.nowPlayingObservableObject.nowPlaying[Streams.Main.Name]!.title)
//                .font(Font.system(size: 20, weight: .medium, design: .default))
//       Text(self.nowPlayingObservableObject.nowPlaying[Streams.Main.Name]!.artist)
            //                .font(Font.system(size: 17, weight: .light, design: .default))
            //                .padding(.top, 11)
            //                .foregroundColor(Design.Primary.LightGray)
            //                .multilineTextAlignment(.center)
                    }.padding()          .foregroundColor(Design.Primary.DarkGray)
//                .padding(.top, 20)
//                .multilineTextAlignment(.center)
//
//
    }
}

struct TrackMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMetadataView()
    }
}
