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

        let subscriber = Subscribers.Sink<Playback, Never>(
            receiveCompletion: {
                _ in
            }) { value in
                if UserDefaults.standard.bool(forKey: "ArtworkEnabled") == false {
                    self.image = .loading(image: placeholderImage)
                    return
                }

                if case let .playing(track) = value {
                if let artworkImage = URL(string: track.artwork) {
                    self.image = .loading(image: placeholderImage)

                    let task = URLSession.shared.dataTask(with: artworkImage, completionHandler: { (data, _, _) -> Void in
                        guard let data = data else { return }
                        DispatchQueue.main.async {
                            self.image = .playing(image: UIImage(data: data)!)
                        }
                    })

                    task.resume()
                } else {
                    self.image = .nothing(image: placeholderImage)
                }
            }
        }

        nowPlayingObservableObject.$playback.subscribe(subscriber)

    }
}
