//
//  RadioControlsView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct RadioControlsView: View {
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .shared

    var body: some View {
        ZStack {
            HStack {
                if case let .playing(track) = nowPlaying.playback {
                    LikeButtonView(track: track)
                }

                Spacer()

                if case let .playing(track) = nowPlaying.playback {
                    // Padding to set the same width as LikeButtonView
                    ShareButtonView(track: track).padding(.horizontal, 3.9)
                }
                if case .live = nowPlaying.playback {
                    DiscussButtonView()
                }
            }
            RadioPlayButtonView()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 30)
    }
}

struct RadioControlView_Previews: PreviewProvider {
    static var previews: some View {
        RadioControlsView()
    }
}
