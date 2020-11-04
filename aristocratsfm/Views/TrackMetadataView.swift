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
    
    var artworkView: some View {
        let playback = nowPlaying.playback;
        
        var fillWrapperColor = colorScheme == .dark ? Design.Primary.Base : Color.white
        if colorScheme == .dark {
            if case let .playing(_, artwork) = playback {
                if (artwork != nil) {
                    fillWrapperColor = Design.Primary.DarkGray
                }
            }
        }
        
        let rectangle = Rectangle()
            .fill(fillWrapperColor)
            .padding()
            .aspectRatio(1.0, contentMode: .fit)
        
        return rectangle
    }
    
    var artistText: some View {
        let playback = nowPlaying.playback;
        var author = "Аристократи"
        
        if case let .playing(track, _) = playback {
            author = track.artist
        }
        
        return Text(author)
            .font(Font.system(size: 20, weight: .medium, design: .default))
            .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.DarkGray)
            .padding(.top, 20)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
    }
    
    var songText: some View {
        let playback = nowPlaying.playback;
        var song = "..."
        
        if case let .playing(track, _) = playback {
            song = track.song
        }
        
        return Text(song)
            .font(Font.system(size: 17, weight: .light, design: .default))
            .padding(.top, 11)
            .padding(.horizontal)
            .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.LightGray)
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        let playback = nowPlaying.playback;
        
        let artworkImageName = colorScheme == .dark ? "AristocratsLogoWhite" : "AristocratsLogoPurple"
        
        let artworkImage = Image(artworkImageName)
            .padding()
            .scaleEffect(0.5, anchor: .center)
        
        var artworkImageView: ImageView?
        if case let .playing(_, artwork) = playback {
            artworkImageView = ImageView(withURL: artwork?.images.first?.thumbnails.large ?? "")
        }
        
        return VStack() {
            // TODO Optimize it somehow
            if (artworkImageView != nil) {
                artworkView.overlay(artworkImageView)
            } else {
                artworkView.overlay(artworkImage)
            }
            
            artistText
            songText
        }
    }
}

struct TrackMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMetadataView()
        
    }
}
