//
//  AristocratsMainView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct AristocratsMainView: View {
    @State var isPlaylistPresented = false

    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            TrackMetadataView()
            RadioControlView()
            Spacer()

            Button(action: {
                self.isPlaylistPresented.toggle()
            }) {
                Text("ПЛЕЙЛИСТ")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    .padding(.horizontal)
                    .background(RoundedCornerView(color: Design.Primary.Base, tl: 30, tr: 30, bl: 0, br: 0))
            }.sheet(isPresented: $isPlaylistPresented) {
                PlaylistView()
            }
        }).padding(.top, 30).edgesIgnoringSafeArea(.all)
    }
}

struct AristocratsMainView_Previews: PreviewProvider {
    static var previews: some View {
        AristocratsMainView()
    }
}
