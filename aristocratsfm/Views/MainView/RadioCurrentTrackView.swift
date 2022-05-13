//
//  RadioCurrentTrackView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI
import Combine

struct RadioCurrentTrackView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var nowPlaying: NowPlayingObservableObject = .shared
    @ObservedObject var imageLoader: ImageLoaderObservableObject = .shared

    var artistText: some View {
        let playback = nowPlaying.playback
        var author = "…"

        if case let .playing(track, _) = playback {
            author = track.artist
        }

        return Text(author)
            .font(Font.system(size: 17, weight: .light, design: .default))
            .padding(.top, 11)
            .padding(.horizontal)
            .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.LightGray)
            .multilineTextAlignment(.center)
    }

    var songText: some View {
        let playback = nowPlaying.playback
        var song = NSLocalizedString("aristocrats", comment: "Aristocrats")

        if case let .playing(track, _) = playback {
            song = track.song
        }

        return Text(song)
            .font(Font.system(size: 20, weight: .medium, design: .default))
            .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.DarkGray)
            .padding(.top, 20)
            .padding(.horizontal)
            .multilineTextAlignment(.center)

    }

    var body: some View {
        let artworkImage: UIImage

        switch imageLoader.image {
        case .nothing(image: let placeholder),
             .loading(image: let placeholder):
            artworkImage = placeholder
        case .playing(image: let uiImage):
            artworkImage = uiImage
        }

        // FIXME Fix it someday.
        //  The difference is only loading lottie overlay
        var artwork =
            AnyView(
                Image(uiImage: artworkImage)
                .resizable()
                .scaledToFit()
                .padding()
            )

        if case .loading = imageLoader.image {
            artwork = AnyView(
                artwork
                .overlay(LottieView().opacity(0.7))
            )
        }

        return VStack {
            artwork

            songText
            artistText
        }
    }
}

struct RadioCurrentTrackView_Previews: PreviewProvider {
    static var previews: some View {
        RadioCurrentTrackView()
    }
}
