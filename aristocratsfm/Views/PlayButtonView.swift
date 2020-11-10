//
//  PlayButtonView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI
import AVFoundation
import Lottie

struct PlayButtonView: View {
    @ObservedObject var player: PlayerObservableObject = .shared
    
    func getPlayIconFontSymbol() -> String {
        if player.isPlaying {
            return "pause.fill";
        }

        return "play.fill";
    }
    
    var body: some View {
        let iconImage: String = self.getPlayIconFontSymbol();
        
        //  Put icons to center
        let extraPadding: CGFloat = player.isPlaying ? -1.0 : 3.0;

        ZStack {
            Circle()
                .fill(Color(UIColor(named: "BaseColor")!))
                .frame(maxHeight: 100, alignment: .center)
                .overlay(
                    Button(action: {
                        if (player.isPlaying) {
                            self.player.player?.pause()
                        } else {
                            self.player.playItem(at: Streams.Main.URI)
                            self.player.player?.play()
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }) {
                        if (!player.isLoading) {
                            Image(systemName: iconImage)
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .scaleEffect(0.3)
                                .padding(.leading, extraPadding)
                        }
                    }
                )
            
            
            if (player.isLoading) {
                LoadingLottieView()
                    .frame(maxHeight: 100, alignment: .center)
                    .onTapGesture {
                        self.player.player?.pause()
                    }
            }
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonView()
    }
}
