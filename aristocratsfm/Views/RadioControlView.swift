//
//  RadioControlView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct RadioControlView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .shared
    
    @State var currentTrack:AristocratsTrack? = nil

    var body: some View {
        ZStack{
            HStack() {
                
                if case let .playing(track, _) = nowPlaying.playback {
                    LikeButton(track: track)
                }
                
                Spacer()
                
                if case let .playing(track, _) = nowPlaying.playback {
                    ShareButton(track: track)
                }

            }
            PlayButton()
        }
            
        .padding(.horizontal)
        .padding(.vertical, 30)
    }
}

struct RadioControlView_Previews: PreviewProvider {
    static var previews: some View {
        RadioControlView()
    }
}
