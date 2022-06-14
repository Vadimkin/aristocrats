//
//  ImageLoaderObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import Foundation
import Combine
import UIKit
import SwiftUI

enum ArtworkImage: Equatable {
    case nothing(image: UIImage)
    case loading(image: UIImage)
    case playing(image: UIImage)
}

class ArtworkImageObservableObject: ObservableObject {
    static let shared = ArtworkImageObservableObject.init()
    let nowPlayingObservableObject: NowPlayingObservableObject = .shared

    @AppStorage("ArtworkEnabled") private var isArtworkEnabled = true
    @Published var image: ArtworkImage = .nothing(image: UIImage(named: "AristocratsCat")!)

    init() {
        let placeholderImage = UIImage(named: "AristocratsCat")!

        // TODO Do not wait for publisher when isArtworkEnabled is disabled
        //  or was just disabled.
        nowPlayingObservableObject.$playback.flatMap { playback -> AnyPublisher<ArtworkImage, Never> in
            let isArtworkEnabled = UserDefaults.standard.isArtworkEnabled

            if !isArtworkEnabled {
                return Just(ArtworkImage.nothing(image: placeholderImage)).eraseToAnyPublisher()
            }

            if case let .playing(track) = playback {
                // Artwork can't be determined,
                // so render only placeholder picture
                if (track.artwork == "") {
                    return Just(ArtworkImage.nothing(image: placeholderImage)).eraseToAnyPublisher()
                }
            }

            if case .live = playback {
                return Just(ArtworkImage.nothing(image: placeholderImage)).eraseToAnyPublisher()
            }

            let placeholder = ArtworkImage.loading(image: placeholderImage)

            guard
                isArtworkEnabled,
                case let .playing(track) = playback,
                let artworkImageURL = URL(string: track.artwork)
            else {
                return Just(placeholder).eraseToAnyPublisher()
            }

            return URLSession.shared
                .dataTaskPublisher(for: artworkImageURL)
                .map(\.data)
                .map(UIImage.init(data:))
                .replaceError(with: .none)
                .map { image in
                    image.map(ArtworkImage.playing(image:)) ?? placeholder
                }
                .eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$image)
    }
}

extension UserDefaults {
    @objc dynamic var isArtworkEnabled: Bool {
        bool(forKey: "ArtworkEnabled")
    }
}
