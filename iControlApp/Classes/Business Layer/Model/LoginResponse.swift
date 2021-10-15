//
//  LoginRequestResponse.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import Foundation

struct LoginResponse: Decodable {
    var refresh: String?
    var access: String?
    let user: User?
}
