//
//  UIImage.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 01.11.2020.
//

import MediaPlayer

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
