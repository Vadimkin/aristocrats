//
//  RadioControlsView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct RadioControlsView: View {
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .shared

    @State var currentTrack: AristocratsTrack?

    var body: some View {
        ZStack {
            HStack {
                if case let .playing(track, _) = nowPlaying.playback {
                    LikeButtonView(track: track)
                }

                Spacer()

                if case let .playing(track, _) = nowPlaying.playback {
                    if track.isLive {
                        DiscussButtonView()
                    } else {
                        ShareButtonView(track: track)
                    }
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
