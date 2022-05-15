//
//  ImageLoaderObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import Foundation
import Combine
import UIKit

enum ArtworkImage: Equatable {
    case nothing(image: UIImage)
    case loading(image: UIImage)
    case playing(image: UIImage)
}

class ArtworkImageObservableObject: ObservableObject {
    static let shared = ArtworkImageObservableObject.init()
    let nowPlayingObservableObject: NowPlayingObservableObject = .shared

    @Published var image: ArtworkImage = .nothing(image: UIImage(named: "AristocratsCat")!)

    init() {
        let placeholderImage = UIImage(named: "AristocratsCat")!

        UserDefaults.standard
            .publisher(for: \.isArtworkEnabled)
            .combineLatest(nowPlayingObservableObject.$playback)
            .flatMap { isArtworkEnabled, playback -> AnyPublisher<ArtworkImage, Never> in
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
    var isArtworkEnabled: Bool {
        bool(forKey: "ArtworkEnabled")
    }
}
