//
//  RadioControlView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 26.09.2020.
//

import SwiftUI

struct RadioControlView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "suit.heart")
                    .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.Gray)
                    .font(Font.title)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 12)
            }

            Spacer()

            PlayButton()

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(colorScheme == .dark ? Color.white : Design.Primary.Gray)
                    .font(Font.title)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 12)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
}

struct RadioControlView_Previews: PreviewProvider {
    static var previews: some View {
        RadioControlView()
    }
}
