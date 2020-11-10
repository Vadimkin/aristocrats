//
//  UIApplication.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 08.11.2020.
//

import SwiftUI

extension UIApplication {
    static func withHomeButton() -> Bool {
        // Returns true if it's iPhone with home button
        if #available(iOS 11.0, *),let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), keyWindow.safeAreaInsets.bottom > 0 {
            return false
        }
        return true
    }
}
