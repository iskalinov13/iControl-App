//
//  UIView+Extension.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 11.05.21.
//

import UIKit
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addCornerRadius(_ radius: CGFloat = 4) {
        layer.cornerRadius = radius
    }

    func addBorderLine(width: CGFloat = 1, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func makeRounded() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }

    func addShadow(
        cornerRadius: CGFloat = 2,
        shadowColor: UIColor = UIColor.black,
        shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0),
        shadowOpacity: Float = 0.25,
        shadowRadius: CGFloat = 2
    ) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
