//
//  TrackMetadataView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI
import Combine

struct TrackMetadataView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .shared
    
    var stream: String? = Streams.Main.Name
    
    var body: some View {
        let playback = nowPlaying.playback;
        
        let artworkImageName = colorScheme == .dark ? "AristocratsLogoWhite" : "AristocratsLogoPurple"
        
        let ArtworkImage = Image(artworkImageName)
            .padding()
            .scaleEffect(0.5, anchor: .center)
        
        let ImageWrapperView = Rectangle()
            .fill(colorScheme == .dark ? Design.Primary.Base : Color.white)
            .padding()
            .aspectRatio(1.0, contentMode: .fit)
            .cornerRadius(30)
//          TODO To use or not to use?
//            .frame(maxWidth: 300, alignment: .center)
        
        VStack() {
            switch playback {
            case .nothing:
                VStack(alignment: .center) {
                    ImageWrapperView
                        .overlay(ArtworkImage);
                    
                    Text("Аристократи")
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                        .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.DarkGray)
                        .padding(.top, 20)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Text("...")
                        .font(Font.system(size: 17, weight: .light, design: .default))
                        .padding(.top, 11)
                        .padding(.horizontal)
                        .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.LightGray)
                        .multilineTextAlignment(.center)
                }
                
            case let .playing(track, artwork):
                if (artwork != nil) {
                    ImageWrapperView.overlay(
                        ImageView(withURL: artwork?.images.first?.thumbnails.large ?? "")
                    );
                } else {
                    ImageWrapperView
                        .overlay(ArtworkImage);
                }
                
                Text(track.song)
                    .font(Font.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.DarkGray)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Text(track.artist)
                    .font(Font.system(size: 17, weight: .light, design: .default))
                    .padding(.top, 11)
                    .padding(.horizontal)
                    .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.LightGray)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct TrackMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMetadataView()
        
    }
}
