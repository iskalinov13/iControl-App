//
//  KeyboardObserving.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import UIKit
protocol KeyboardObserving: class {
    func keyboardWillShow(_ height: CGFloat)
    func keyboardWillHide()
    func registerForKeyboardEvents()
    func unregisterFromKeyboardEvents()
}

extension KeyboardObserving {
    func registerForKeyboardEvents() {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
            self?.keyboardWillShow(keyboardHeight)
        }

        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] _ in
            self?.keyboardWillHide()
        }
    }
    
    func unregisterFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
