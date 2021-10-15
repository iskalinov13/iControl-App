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
    let image1: String?
    let image2: String?
    let image3: String?
    
    var userImages: [String?]? {
        var images: [String] = []
        guard
            let image1 = image1,
            let image2 = image2,
            let image3 = image3
        else { return nil }
        images.append("\(Config.baseUrl)\(image1)")
        images.append("\(Config.baseUrl)\(image2)")
        images.append("\(Config.baseUrl)\(image3)")
        return images
    }
}

struct CurrentUser {
    static var id: Int?
    static var username: String?
    static var name: String?
    static var access: String?
    static var refresh: String?
    static var userImages: [String?]?
}
