//
//  LoginRequestResponse.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 5.05.21.
//

import Foundation

struct LoginRequestResponse: Decodable {
    var refresh: String?
    var access: String?
    //let id: Int?
    let user: User?
}
