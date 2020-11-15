//
//  ImageLoaderObservableObject.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import Foundation
import Combine

class ImageLoaderObservableObject: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(url: URL) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) -> Void in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        })

        task.resume()
    }
}
