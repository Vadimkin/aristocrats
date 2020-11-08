//
//  AristocratsMainView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct AristocratsMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    // All Screens Stack:
                    VStack(alignment: .leading, spacing: 0, content: {
                        
                        // First screen:
                        VStack(alignment: .center, spacing: 0, content: {
//                            TopBarView()

                            TrackMetadataView()
                            
                            Spacer()
                            
                            RadioControlView()
                            
                            Spacer()

                            Text("ПЛЕЙЛИСТ")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                                .padding(.bottom, UIApplication.withoutHomeButton() ? 30 : 20)
                                .padding(.horizontal)
                                .background(RoundedCornerView(color: Color(UIColor(named: "BaseColor")!), tl: 20, tr: 20, bl: 0, br: 0))
                                .onTapGesture {
                                    withAnimation {
                                        scrollView.scrollTo("Playlist", anchor: .top)
                                    }
                                }
                        })
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .center
                        )
                        // END First screen
                        VStack(alignment: .leading) {
                            PlaylistView()
                                .id("Playlist")
                        }
                        
                    })
                }
            }
        }
        .padding(.top, UIApplication.withoutHomeButton() ? 30 : 50)
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
