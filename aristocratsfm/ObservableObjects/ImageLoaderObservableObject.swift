//
//  ImageLoaderObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import Foundation
import Combine
import UIKit

enum ImageLoader: Equatable {
    case nothing(image: UIImage)
    case loading(image: UIImage)
    case playing(_ image: UIImage)
}

class ImageLoaderObservableObject: ObservableObject {
    static let shared = ImageLoaderObservableObject.init()
    let nowPlayingObservableObject: NowPlayingObservableObject = .shared

    @Published var image: ImageLoader = .nothing(image: UIImage(named: "AristocratsCat")!)

    init() {
        let placeholderImage = UIImage(named: "AristocratsCat")!

        let subscriber = Subscribers.Sink<Playback, Never>(
            receiveCompletion: {
                _ in
            }) { value in
                if case let .playing(_, coverArt) = value {

                // TODO Respect "Download Artworks" toggle from settings
                //  so artworks will not be downloaded
                if (coverArt != nil) {
                    if let artworkUnsecuredImage = coverArt?.images.first?.thumbnails.large,
                       let artworkUnsecuredURL = URL(string: artworkUnsecuredImage) {
                        let artworkImage = URL.alwaysSecuredURL(insecuredURL: artworkUnsecuredURL)
                        self.image = .loading(image: placeholderImage)

                        let task = URLSession.shared.dataTask(with: artworkImage, completionHandler: { (data, _, _) -> Void in
                            guard let data = data else { return }
                            DispatchQueue.main.async {
                                self.image = .playing(UIImage(data: data)!)
                            }
                        })

                        task.resume()
                    }
                } else {
                    self.image = .nothing(image: placeholderImage)
                }
            }
        }

        nowPlayingObservableObject.$playback.subscribe(subscriber)

    }
}
