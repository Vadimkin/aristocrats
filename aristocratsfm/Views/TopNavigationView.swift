//
//  NavigationView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import SwiftUI

struct TopNavigationView: View {
    @State var showingFavorites = false
    @State var showingSettings = false

    @Environment(\.managedObjectContext) var moc

    func getImage(systemName: String) -> some View {
        return Image(systemName: systemName)
            .font(.subheadline)
            .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
            .padding(.all, 12)
    }

    var body: some View {
        HStack {
            Button(action: {
                self.showingFavorites.toggle()
            }) {
                self.getImage(systemName: "text.badge.star")
            }.sheet(isPresented: $showingFavorites) {
                FavoriteListView()
                    .environment(\.managedObjectContext, self.moc)
            }

            Spacer()

            Button(action: {
                self.showingSettings.toggle()
            }) {
                self.getImage(systemName: "gearshape")
            }.sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environment(\.managedObjectContext, self.moc)
            }
        }
        .frame(maxHeight: 50, alignment: .trailing)
        .padding(.top, 20)
        .padding(.horizontal, 10)
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavigationView()
    }
}
