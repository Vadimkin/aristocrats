//
//  ImageLoaderView.swift
//  aristocratsfm
//
//  Created by Maksym Ambroskin on 14.10.2020.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @ObservedObject private var imageLoader: ImageLoaderObservableObject
    @State var image: UIImage = UIImage()
    @State private var isLoaded: Bool = false
    
    init(withURL url:URL) {
        imageLoader = ImageLoaderObservableObject(url:url)
    }
    
    var body: some View {
        var imageView = AnyView(Image(uiImage: image)
                                    .resizable()
                                    .padding()
                                    .scaledToFit()
                                    .clipped()
                                    .shadow(
                                        color: Color(red: 0.51, green: 0.51, blue: 0.51, opacity: 0.1),
                                        radius: 4,
                                        x:0,
                                        y:2
                                    ))
        
        if (!isLoaded) {
            imageView = AnyView(imageView
                                    .overlay(
                                        Image("CatBackgroundImage")
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                    )
                                    .overlay(LottieView().opacity(0.7)))
        }
        
        return imageView.onReceive(imageLoader.didChange) { data in
            self.isLoaded = true
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
