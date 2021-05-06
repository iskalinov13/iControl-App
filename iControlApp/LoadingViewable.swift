//
//  LoadingViewable.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import Foundation
import NVActivityIndicatorView

protocol LoadingViewable: NVActivityIndicatorViewable where Self: UIViewController {
    func showLoader()
    func hideLoader()
}

extension LoadingViewable {
    func showLoader() {
        self.startAnimating(type: .ballScaleRippleMultiple)
    }
    
    func hideLoader() {
        self.stopAnimating()
    }
}
