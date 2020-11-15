//
//  LatestTracksHeadlineView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 14.11.2020.
//

import SwiftUI

struct LatestTracksHeadlineView: View {
    let latestTracksString = NSLocalizedString("latestTracks", comment: "Latest Tracks")

    var body: some View {
        Text(latestTracksString.uppercased())
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.bottom, UIApplication.withHomeButton() ? 20 : 30)
            .padding(.horizontal)
            .background(
                RoundedCornerView(
                    color: Color(UIColor(named: "BaseColor")!),
                    topLeft: 20,
                    topRight: 20,
                    bottomLeft: 0,
                    bottomRight: 0)
            )
    }
}

struct LatestTracksHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        LatestTracksHeadlineView()
    }
}
