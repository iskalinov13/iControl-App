//
//  BannerNotificationPresentable.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import UIKit
import NotificationBannerSwift

protocol BannerNotificationPresentable {
    func showErrorBanner(_ error: Error)
    func showSuccessBanner(_ title: String, _ subtitle: String)
    func showNotificationBanner(_ title: String, _ subtitle: String)
}

extension BannerNotificationPresentable {
    func showErrorBanner(_ error: Error) {
        var subtitle = ""
        if let locErr = error as? LocalizableError {
            subtitle = locErr.localizedErrorDescription
        } else {
            subtitle = error.localizedDescription
        }
        let banner = FloatingNotificationBanner(
            title: "error".localized,
            subtitle: subtitle,
            style: .danger
        )
        banner.show(
            queuePosition: .front,
            bannerPosition: .top,
            cornerRadius: 10,
            shadowBlurRadius: 1
        )
    }

    func showSuccessBanner(_ title: String, _ subtitle: String) {
        let banner = FloatingNotificationBanner(
            title: title,
            subtitle: subtitle,
            style: .success
        )
        banner.show(
            queuePosition: .front,
            bannerPosition: .top,
            cornerRadius: 10,
            shadowBlurRadius: 1
        )
    }

    func showNotificationBanner(_ title: String, _ subtitle: String) {
        let banner = FloatingNotificationBanner(
            title: title,
            subtitle: subtitle,
            style: .info
        )
        banner.show(
            queuePosition: .front,
            bannerPosition: .top,
            cornerRadius: 10,
            shadowBlurRadius: 1
        )
    }
}

