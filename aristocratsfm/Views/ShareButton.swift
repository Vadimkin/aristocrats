//
//  ShareButton.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct ShareButton: View {
    var track: AristocratsTrack?
    @Environment(\.colorScheme) var colorScheme
    
    func shareTrack() {
        guard let unwappedTrack = track else { return }
        // TODO Consider about URL share (songwhip)
        let av = UIActivityViewController(activityItems: ["\(unwappedTrack.artist) - \(unwappedTrack.song)"], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

    var body: some View {
        Button(action: shareTrack) {
            ZStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.Gray)
                    .padding(.vertical, 12)
                    .padding(.trailing, 10)
                    .frame(maxHeight: 56, alignment: .center)
            }
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton()
    }
}
