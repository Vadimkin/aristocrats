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
            ScrollViewReader { _ in
                VStack(alignment: .leading, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        TopNavigationView()

                        RadioCurrentTrackView()

                        Spacer()

                        RadioControlsView()

                        Spacer(minLength: 1)
                    })
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center
                    )
                })
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
