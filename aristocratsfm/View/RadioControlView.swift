//
//  RadioControlView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct RadioControlView: View {
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {}) {
                Image(systemName: "suit.heart")
                    .foregroundColor(Design.Primary.Gray)
                    .font(Font.title)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 12)
            }

            Spacer()

            PlayButton()

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Design.Primary.Gray)
                    .font(Font.title)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 12)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

struct RadioControlView_Previews: PreviewProvider {
    static var previews: some View {
        RadioControlView()
    }
}
