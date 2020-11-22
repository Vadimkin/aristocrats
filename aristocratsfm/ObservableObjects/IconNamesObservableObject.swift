//
//  IconNames.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 11.11.2020.
//

import Foundation
import UIKit

class IconNamesObservableObject: ObservableObject {
    var iconNames: [String?] = [nil] // nil is application default icon
    @Published var currentIndex = 0
    @Published var currentName = "AppIcon"

    init() {
        getAlternateIconNames()

        refreshCurrentIcon()
    }

    func refreshCurrentIcon() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
            self.currentName = currentIcon
        } else {
            self.currentIndex = 0
            self.currentName = "AppIcon"
        }
    }

    func getAlternateIconNames() {
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
            let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {

             for (_, value) in alternateIcons {

                 guard let iconList = value as? [String: Any] else {return}
                 guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                     else {return}

                 guard let icon = iconFiles.first else {return}
                 iconNames.append(icon)
             }
        }
    }
}
