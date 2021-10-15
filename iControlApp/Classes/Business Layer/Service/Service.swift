//
//  Service.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 8.05.21.
//

import Foundation
import SwiftyJSON

protocol Service {
    func convert<T: Decodable>(json: JSON, into type: T.Type) throws -> T

}

extension Service {
    func convert<T: Decodable>(json: JSON, into type: T.Type) throws -> T {
        let jsonData = try json.rawData()
        let decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return try decoder.decode(type.self, from: jsonData)
    }
}
