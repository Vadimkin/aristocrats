//
//  AristocratsMainView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct AristocratsMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var isBottom: Bool {
        // Returns true if it's iPhone without stupid home button
        if #available(iOS 11.0, *),let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), keyWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    // All Screens Stack:
                    VStack(alignment: .leading, spacing: 0, content: {
                        
                        // First screen:
                        VStack(alignment: .center, spacing: 0, content: {
                            TrackMetadataView()
                            
                            Spacer()
                            
                            RadioControlView()

                            Text("ПЛЕЙЛИСТ")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                                .padding(.bottom, isBottom ? 30 : 20)
                                .padding(.horizontal)
                                .background(RoundedCornerView(color: Design.Primary.Base, tl: 20, tr: 20, bl: 0, br: 0))
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
                            PlaylistView().id("Playlist")
                        }
                        
                    })
                }
            }
        }
        .padding(.top, 30)
        .background(colorScheme == .dark ? Design.Primary.DarkGray : Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AristocratsMainView_Previews: PreviewProvider {
    static var previews: some View {
        AristocratsMainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        
        AristocratsMainView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
