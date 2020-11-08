//
//  ShareButton.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct ShareButton: View {
    var track: AristocratsTrack?
    
    func shareTrack() {
        guard let unwappedTrack = track else { return }
        // TODO Consider about URL share (songwhip)
        let av = UIActivityViewController(activityItems: ["\(unwappedTrack.artist) - \(unwappedTrack.song)"], applicationActivities: nil)
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
    }

    var body: some View {
        Button(action: shareTrack) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.6)
                .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
                .padding(.vertical, 12)
                .padding(.trailing, 10)
                .frame(maxHeight: 70, alignment: .trailing)
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton()
    }
}
