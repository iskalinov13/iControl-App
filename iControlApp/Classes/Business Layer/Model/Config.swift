//
//  Config.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 12.05.21.
//

import UIKit

public class Config: NSObject {
    public static var baseUrl = "http://172.20.10.2:8000"
    
    // Логотип, иконки и т.д.
    public static var imgAuthPage = UIImage(named: "img-background", in: Bundle(for: Config.self), compatibleWith: nil)
}
