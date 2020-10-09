//
//  ContentView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AristocratsMainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
