//
//  User.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 28.04.21.
//

import Foundation
struct User: Codable {
    let id: Int?
    let username: String?
    let name: String?
    let surname: String?
    let data_joined: Date?
    let is_superuser: Bool?
}

struct CurrentUser {
    static var id: Int?
    static var access: String?
    static var refresh: String?
    
}
