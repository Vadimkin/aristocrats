//
//  NavigationView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 10.11.2020.
//

import SwiftUI

struct TopNavigationView: View {
    @State var showingDetail = false
    @Environment(\.managedObjectContext) var moc
    
    func getImage(systemName: String) -> some View {
        return Image(systemName: systemName)
            .font(.title2)
            .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
            .padding(.all, 12)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                self.getImage(systemName: "text.badge.star")
            }.sheet(isPresented: $showingDetail) {
                FavoriteListView()
                    .environment(\.managedObjectContext, self.moc)
            }
            
            Spacer()
            
            self.getImage(systemName: "gearshape")
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavigationView()
    }
}
