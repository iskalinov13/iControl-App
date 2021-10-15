//
//  AlertPresentable.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 8.05.21.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String, message: String?, submitTitle: String, completion: @escaping () -> Void)
    func showErrorAlert(_ error: LocalizableError)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(
        title: String,
        message: String?,
        submitTitle: String = "Oк",
        completion: @escaping () -> Void = {}
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: submitTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ error: LocalizableError) {
        guard error.canDisplayAlert else { return }
        showAlert(title: error.localizedErrorTitle, message: error.localizedErrorDescription)
    }
}
