//
//  TelegramURI.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 15.11.2020.
//

import SwiftUI

enum TelegramType {
    case person
    case publicChannel
    case chat
}

struct TelegramURI {
    var type: TelegramType
    var id: String

    func open() {
        let telegramAppURL: URL
        let telegramFallbackURL: URL

        switch self.type {
        case .chat: do {
            telegramAppURL = URL(string: "tg://join?invite=\(id)")!
            telegramFallbackURL = URL(string: "https://t.me/joinchat/\(id)")!
        }
        case .publicChannel: do {
            telegramAppURL = URL(string: "tg://resolve?domain=\(id)")!
            telegramFallbackURL = URL(string: "https://t.me/\(id)")!
        }
        case .person: do {
            telegramAppURL = URL(string: "tg://resolve?domain=\(id)")!
            telegramFallbackURL = URL(string: "https://t.me/\(id)")!
        }
        }

        if UIApplication.shared.canOpenURL(telegramAppURL) {
            UIApplication.shared.open(telegramAppURL)
        } else {
            UIApplication.shared.open(telegramFallbackURL)
        }
    }
}
