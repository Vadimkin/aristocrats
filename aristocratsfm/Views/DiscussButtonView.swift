//
//  DiscussButtonVIew.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 15.11.2020.
//

import SwiftUI

struct DiscussButtonView: View {
    func openTelegramChat() {
        TelegramURI(type: .chat, id: Contacts.TelegramChatID).open()
    }

    var body: some View {
        Button(action: openTelegramChat) {
            Image(systemName: "ellipsis.bubble")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(UIColor(named: "ButtonForegroundColor")!))
                .padding(.vertical, 12)
                .frame(maxHeight: 50, alignment: .leading)
        }
    }
}

struct DiscussButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussButtonView()
    }
}
