//
//  String+Extension.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 8.05.21.
//

import Foundation

extension String {
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: "", table: "")
    }
}
