//
//  ShareButtonView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 07.11.2020.
//

import SwiftUI

struct ShareButtonView: View {
    var track: AristocratsTrack?
    
    func shareTrack() {
        guard let unwappedTrack = track else { return }
        // TODO Consider about URL share (songwhip)
        
        let activityItems = ["\(unwappedTrack.artist) - \(unwappedTrack.song)"]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activity.popoverPresentationController?.sourceView = UIApplication.shared.windows.first?.rootViewController!.view
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(activity, animated: true, completion: nil)
    }

    var body: some View {
        Button(action: shareTrack) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
                .padding(.vertical, 12)
                .padding(.trailing, 10)
                .frame(maxHeight: 50, alignment: .trailing)
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView()
    }
}
