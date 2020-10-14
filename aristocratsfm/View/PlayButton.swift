//
//  PlayButton.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI
import AVFoundation
import Lottie

struct PlayButton: View {
    @ObservedObject var player: PlayerObservableObject = .shared
    
    func getPlayIconFontSymbol() -> String? {
        if player.isPlaying {
            return "pause.fill";
        }
        
        if player.isLoading {
            return nil
        }
        
        return "play.fill";
    }
    
    var body: some View {
        let iconImage: String? = self.getPlayIconFontSymbol();
        
        //  Put icons to center
        let extraPadding: CGFloat = player.isPlaying ? -1.0 : 3.0;
        
        ZStack {
            PlayIconLottieView(isLoading: $player.isLoading, isPlaying: $player.isPlaying).frame(width: 200, height: 200)
            
            if (!player.isLoading) {
                Button(action: {
                    if (player.isPlaying) {
                        self.player.player?.pause()
                    } else {
                        self.player.playItem(at: Streams.Main.URI, stream: Streams.Main.Name)
                        self.player.player?.play()
                    }
                }) {
                    Image(systemName: iconImage!)
                        .foregroundColor(.white)
                        .font(Font.custom("Play", fixedSize: 57))
                        .padding(.leading, extraPadding)
                }.frame(width: 200, height: 200)
            }
            
            if (player.isLoading) {
                LoadingLottieView().frame(width: 110, height: 110)
            }
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
