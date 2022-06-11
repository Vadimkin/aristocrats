//
//  IconNames.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 11.11.2020.
//

import Foundation
import UIKit

class IconNamesObservableObject: ObservableObject {
    let iconNames: [String?] = [nil, "Purple-Icon-App", "Dark-Icon-App"] // nil is application default icon
    @Published var currentIndex = 0
    @Published var currentName = "AppIcon"

    init() {
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
}
