//
//  UIColor+Extension.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import UIKit
extension UIColor {
    static let background = UIColor(named: "color-background")
    static let main = UIColor(named: "color-main")
}

extension UIColor {
    enum BannerNotification {
        static func backgroundColor(for style: BannerNotificationView.Style) -> UIColor {
            switch style {
            case .error: return .red
            case .notification: return .gray
            case .success: return green
            }
        }
    }
}
