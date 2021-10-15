//
//  CommonCoreError.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 8.05.21.
//

import Foundation

enum CommonCoreError: Error {
    case noData
    case responseSerializationFailed(error: Error)
    case networkError(error: Error)
    case serverError(error: Error)
    case emptyRequiredFields
    case unknownError(error: Error)
    case unAuthorized
    case passwordVerification
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "error.network.msg".localized
        case .responseSerializationFailed:
            return "error.serialization.msg".localized
        case .serverError:
            return "error.server.msg".localized
        case .unknownError:
            return "error.unknown.msg".localized
        case .noData:
            return "error.no.data.msg".localized
        case .emptyRequiredFields:
            return "error.empty.required.msg".localized
        case .unAuthorized:
            return "error.unauthorized.msg".localized
        case .passwordVerification:
            return "error.password.verification.msg".localized
        }
    }
}

extension CommonCoreError: LocalizableError {
    var localizedErrorDescription: String {
        return self.localizedDescription
    }
}
