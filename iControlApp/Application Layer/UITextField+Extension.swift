//
//  UITextField+Extension.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import UIKit
extension UITextField {
    func setPlaceHolderColor(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
}
