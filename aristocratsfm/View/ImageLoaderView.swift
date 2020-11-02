//
//  ImageLoaderView.swift
//  aristocratsfm
//
//  Created by Maksym Ambroskin on 14.10.2020.
//

import Foundation
import SwiftUI
import Combine

struct ImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .padding()
            .scaledToFit()
            .clipped()
            .shadow(
                color: Color(red: 0.51, green: 0.51, blue: 0.51, opacity: 0.1),
                radius: 4,
                x:0,
                y:2
            )
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
