//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  UIColor.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import UIKit

extension UIColor {

    static var SemaphoreBlue: UIColor {
        return UIColor(hex: 0x00478F)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
