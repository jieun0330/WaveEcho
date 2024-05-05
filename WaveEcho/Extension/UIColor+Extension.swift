//
//  UIColor+Extension.swift
//  WaveEcho
//
//  Created by 박지은 on 5/3/24.
//

import UIKit

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIColor {
    func asImage(_ width: CGFloat = UIScreen.main.bounds.width, _ height: CGFloat = 1.0) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
            setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
