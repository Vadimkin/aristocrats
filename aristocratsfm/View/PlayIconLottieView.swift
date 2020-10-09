//
//  PlayIconLottieView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 03.10.2020.
//

import SwiftUI
import Lottie

struct PlayIconLottieView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var name: String! = "AristocratsBufferingAnimation"
    @Binding var isLoading:Bool
    @Binding var isPlaying:Bool
    
    var animationView = AnimationView()
    
    class Coordinator: NSObject {
        var parent: PlayIconLottieView
        
        init(_ animationView: PlayIconLottieView) {
            self.parent = animationView
            super.init()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<PlayIconLottieView>) -> UIView {
        let view = UIView()
        
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayIconLottieView>) {
        let animationView = context.coordinator.parent.animationView;
        animationView.loopMode = .loop
        
        if (self.isLoading && !animationView.isAnimationPlaying) {
            animationView.animationSpeed = 1;
            animationView.play()
        }
        
        if (!self.isLoading && !self.isPlaying && animationView.isAnimationPlaying) {
            animationView.stop()
        }
        
        if (self.isPlaying) {
            // TODO Stop or just animate as slow [?]
            animationView.stop()
//            animationView.animationSpeed = 0.3;
        }
    }
}
