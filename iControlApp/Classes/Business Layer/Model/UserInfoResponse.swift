//
//  UserInfoResponse.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 11.05.21.
//

import Foundation

struct UserInfoResponse: Codable {
    let id: Int?
    let password: String?
    let lastLogin: Date?
    let username: String?
    let dataJoined: Date?
    let name: String?
    let surname: String?
    let image1: String?
    let image2: String?
    let image3: String?
    let isAdmin: Bool?
    let isActive: Bool?
    let isStaff: Bool?
    let isSuperUser: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case password
        case lastLogin = "last_login"
        case username
        case dataJoined = "data_joined"
        case name
        case surname
        case image1
        case image2
        case image3
        case isAdmin = "is_admin"
        case isActive = "is_active"
        case isStaff = "is_staff"
        case isSuperUser = "is_superuser"
    }
}
