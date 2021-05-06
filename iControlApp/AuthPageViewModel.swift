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
    var didFailedRequest: Callback<Error>?
    var didLogIn: VoidCallback?
    
    func login(_ phone: String, _ password: String) {
        didStartRequest?()
        authService.login(
            phone: phone,
            password: password,
            success: { [weak self] response in
                
                CurrentUser.id = response.user?.id
                CurrentUser.access = response.access
                CurrentUser.refresh = response.refresh
                self?.didEndRequest?()
                self?.didLogIn?()
            },
            failure: { [weak self] error in
                self?.didFailedRequest?(error)
                self?.didEndRequest?()
            }
        )
    }
}
