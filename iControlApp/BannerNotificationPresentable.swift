//
//  BannerNotificationPresentable.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import UIKit

protocol BannerNotificationPresentable {
    func showErrorBanner(_ error: Error)
    func showSuccessBanner(_ title: String)
    func showNotificationBanner(_ title: String)
}

extension BannerNotificationPresentable {
    func showErrorBanner(_ error: Error) {
        let banner = BannerNotificationView(style: .error)
        if let locErr = error as? LocalizableError {
            banner.title = locErr.localizedErrorDescription
        } else {
            banner.title = error.localizedDescription
        }
        guard let window = UIApplication.shared.keyWindow else { return }
        banner.display(on: window)
    }

    func showSuccessBanner(_ title: String) {
        let banner = BannerNotificationView(style: .success)
        banner.title = title
        guard let window = UIApplication.shared.keyWindow else { return }
        banner.display(on: window)
    }

    func showNotificationBanner(_ title: String) {
        let banner = BannerNotificationView(style: .notification)
        banner.title = title
        guard let window = UIApplication.shared.keyWindow else { return }
        banner.display(on: window)
    }
}

