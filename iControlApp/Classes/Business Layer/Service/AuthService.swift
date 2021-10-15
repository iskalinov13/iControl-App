//
//  AuthService.swift
//  iControlApp
//
//  Created by Farukh Iskalinov on 19.04.21.
//

import Foundation
import Alamofire

struct Result : Decodable {
    let status : Int?
}

struct Result2 : Decodable {
    let open : Bool?
    let isExit : Bool?
    
    enum CodingKeys: String, CodingKey {
        case open
        case isExit = "is_exit"
    }
    
}


protocol AuthService {
    func login(
        phone: String,
        password: String,
        success: @escaping(LoginResponse) -> (),
        failure: @escaping(LocalizableError) -> ()
    )
    
    func enter(
        userId: Int,
        qrCode: String,
        success: @escaping(Result2) -> (),
        failure: @escaping(LocalizableError) -> ()
    )
    
    func changePassword(
        oldPassword: String,
        newPassword: String,
        success: @escaping(ChangePasswordResponse) -> (),
        failure: @escaping(LocalizableError) -> ()
    )
    
    func getUserInfo(
        userId: Int,
        success: @escaping(UserInfoResponse) -> (),
        failure: @escaping(LocalizableError) -> ()
    )
}

class AuthServiceImplementation: AuthService {
    func changePassword(
        oldPassword: String,
        newPassword: String,
        success: @escaping (ChangePasswordResponse) -> (),
        failure: @escaping (LocalizableError) -> ()
    ) {
        let query: Parameters = [
            "password": newPassword,
            "password2": newPassword,
            "old_password": oldPassword
        ]
        print(query)
        guard
            let access = CurrentUser.access,
            let userId = CurrentUser.id
        else {
            failure(CommonCoreError.noData)
            return
        }
        
        guard let url = URL(string: "\(Config.baseUrl)/api/change_password/\(userId)/") else { return }
        print(url)
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(access)"
        ]
        print("Bearer \(String(describing: CurrentUser.access))")
        
        AF.request(url, method: .put, parameters: query, headers: header).responseDecodable { (dataResponse: DataResponse<ChangePasswordResponse, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                success(status)
            case .failure(let error):
                failure(CommonCoreError.serverError(error: error))
            }
        }
    }
    
    func login(
        phone: String,
        password: String,
        success: @escaping (LoginResponse) -> (),
        failure: @escaping (LocalizableError) -> ()
    ) {
        guard let url = URL(string: "\(Config.baseUrl)/token/") else { return }
        print(url)
        let query: Parameters = [
            "username": phone,
            "password": password,
        ]
        print(query)
        AF.request(url, method: .post, parameters: query).responseDecodable { (dataResponse: DataResponse<LoginResponse, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                success(status)
            case .failure(let error):
                failure(CommonCoreError.serverError(error: error))
            }
        }
    }
        
    func enter(
        userId: Int,
        qrCode: String,
        success: @escaping(Result2) -> (),
        failure: @escaping(LocalizableError) -> ()
    ) {
        guard let url = URL(string: "\(Config.baseUrl)/api/send_qr/") else { return }
        print(url)
        let query: Parameters = [
            "user_id": userId,
            "qr_string": qrCode,
        ]
        print(userId)
        guard let access = CurrentUser.access else {
            failure(CommonCoreError.noData)
            return
        }
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(access)"
        ]
        print("Bearer \(String(describing: CurrentUser.access))")
        
        AF.request(url, method: .post, parameters: query, headers: header).responseDecodable { (dataResponse: DataResponse<Result2, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                success(status)
            case .failure(let error):
                failure(CommonCoreError.serverError(error: error))
            }
        }
    }
    
    func getUserInfo(
        userId: Int,
        success: @escaping(UserInfoResponse) -> (),
        failure: @escaping(LocalizableError) -> ()
    ) {
        guard
            let url = URL(string: "\(Config.baseUrl)/api/users/\(userId)/"),
            let access = CurrentUser.access
        else {
            failure(CommonCoreError.noData)
            return
        }
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(access)"
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: nil,
            headers: header
        ).responseDecodable { (dataResponse: DataResponse<UserInfoResponse, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                success(status)
            case .failure(let error):
                failure(CommonCoreError.serverError(error: error))
            }
        }
    }
    
}

