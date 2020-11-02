//
//  AristocratsMainView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct AristocratsMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isPlaylistPresented = false

    var body: some View {
        VStack(alignment: .center, content: {
            TrackMetadataView()
            
            Spacer()
    
            RadioControlView()

//            Button(action: {
//                self.isPlaylistPresented.toggle()
//            }) {
//                Text("ПЛЕЙЛИСТ")
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 20)
//                    .padding(.bottom, 40)
//                    .padding(.horizontal)
//                    .background(RoundedCornerView(color: Design.Primary.Base, tl: 30, tr: 30, bl: 0, br: 0))
//            }.sheet(isPresented: $isPlaylistPresented) {
//                PlaylistView()
//            }
        })
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
