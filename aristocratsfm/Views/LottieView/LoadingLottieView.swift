import SwiftUI
import Lottie

struct LoadingLottieView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    var name: String! = "LoadingDots"

    var animationView = AnimationView()

    class Coordinator: NSObject {
        var parent: LoadingLottieView

        init(_ animationView: LoadingLottieView) {
            self.parent = animationView
            super.init()
        }
    }

    func makeUIView(context: UIViewRepresentableContext<LoadingLottieView>) -> UIView {
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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoadingLottieView>) {
        let animationView = context.coordinator.parent.animationView
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }
}
