//
//  LikeAnimatedButton.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI
import Lottie

struct LikeAnimatedButton: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var name: String! = "LikeAnimatedButton"
    var animated: Bool = true
    
    var animationView = AnimationView()
    
    class Coordinator: NSObject {
        var parent: LikeAnimatedButton
        
        init(_ animationView: LikeAnimatedButton) {
            self.parent = animationView
            super.init()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<LikeAnimatedButton>) -> UIView {
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
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LikeAnimatedButton>) {
        let animationView = context.coordinator.parent.animationView;
        animationView.animationSpeed = 1.5

        if (animated) {
            animationView.play(toProgress: 1, loopMode: .playOnce)
        } else {
            animationView.currentProgress = 1
        }
    }
}
