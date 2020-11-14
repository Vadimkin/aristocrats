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
        
        if let popoverController = activity.popoverPresentationController {
            // FIXME Fix it someday to point to the button
            //  with UIPopoverArrowDirection
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
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
                .frame(maxHeight: 50, alignment: .leading)
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView()
    }
}
