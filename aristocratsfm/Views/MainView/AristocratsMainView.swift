//
//  AristocratsMainView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct AristocratsMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var playlist: PlaylistObservableObject = .shared

    init() {
        UIScrollView.appearance().bounces = false
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    // All Screens Stack:
                    VStack(alignment: .leading, spacing: 0, content: {
                        VStack(alignment: .center, spacing: 0, content: {
                            TopNavigationView()

                            RadioCurrentTrackView()

                            Spacer()

                            RadioControlsView()

                            Spacer(minLength: 1)

                            LatestTracksHeadlineView()
                                 .onTapGesture {
                                     withAnimation {
                                         scrollView.scrollTo("Playlist", anchor: .top)
                                     }
                                 }
                                 .opacity(playlist.playlist != nil ? 1 : 0)
                        })
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .center
                        )
                        // END First screen

                        if playlist.playlist != nil {
                            VStack(alignment: .leading) {
                                PlaylistListView()
                            }.id("Playlist")
                        }
                    })
                }
            }
        }
        .padding(.top, UIApplication.withHomeButton() ? 10 : 30)
        .background(colorScheme == .dark ? Design.Primary.DarkGray : Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct AristocratsMainView_Previews: PreviewProvider {
    static var previews: some View {
        AristocratsMainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        AristocratsMainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
    }
}
#endif
