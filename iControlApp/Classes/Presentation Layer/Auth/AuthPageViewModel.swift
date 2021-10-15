//
//  AuthPageViewModel.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import UIKit

final class AuthPageViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    var didStartRequest: VoidCallback?
    var didEndRequest: VoidCallback?
    var didFailedRequest: Callback<LocalizableError>?
    var didLogIn: VoidCallback?
    
    func login(_ phone: String, _ password: String) {
        didStartRequest?()
        authService.login(
            phone: phone,
            password: password,
            success: { [weak self] response in
                if
                    let access = response.access,
                    let refresh = response.refresh,
                    let id = response.user?.id {
                        CurrentUser.id = id
                        CurrentUser.access = access
                        CurrentUser.refresh = refresh
                        CurrentUser.username = response.user?.username
                        CurrentUser.name = response.user?.name
                        CurrentUser.userImages = response.user?.userImages ?? []
                    self?.didLogIn?()
                } else {
                    self?.didFailedRequest?(CommonCoreError.unAuthorized)
                }
                self?.didEndRequest?()
                
            },
            failure: { [weak self] error in
                self?.didFailedRequest?(error)
                self?.didEndRequest?()
            }
        )
    }
}
