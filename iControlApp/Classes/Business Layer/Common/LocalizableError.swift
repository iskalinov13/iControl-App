//
//  LocalizableError.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import Foundation

public protocol LocalizableError: Error {
    var localizedErrorDescription: String { get }
    var localizedErrorTitle: String { get }
    var canDisplayAlert: Bool { get }
}

extension LocalizableError {
    public var localizedErrorDescription: String {
        return ""
    }
    
    public var localizedErrorTitle: String {
        return "error".localized
    }
    
    public var canDisplayAlert: Bool {
        return true
    }
}
