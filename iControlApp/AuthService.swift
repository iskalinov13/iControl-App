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
}

protocol AuthService {
    func registerUser(
        _ name: String, success: @escaping(Result) -> (), failure: @escaping(AFError) -> ())
    func login(phone: String, password: String, success: @escaping(LoginRequestResponse) -> (), failure: @escaping(AFError) -> ())
    func enter(userId: Int, qrCode: String, success: @escaping(Result2) -> (), failure: @escaping(AFError) -> ())
}

class AuthServiceImplementation: AuthService {
    func login(
        phone: String,
        password: String,
        success: @escaping (LoginRequestResponse) -> (),
        failure: @escaping (AFError) -> ()
    ) {
        guard let url = URL(string: "http://172.20.10.2:8000/token/") else { return }
        print(url)
        let query: Parameters = [
            "username": phone,
            "password": password,
        ]
        
        AF.request(url, method: .post, parameters: query).responseDecodable { (dataResponse: DataResponse<LoginRequestResponse, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                success(status)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func registerUser(_ name: String, success: @escaping(Result) -> (), failure: @escaping(AFError) -> ()) {
        guard let url = URL(string: "http://172.20.21.215:8000/auth/") else { return }
        print(url)
        let dateFormatter = DateFormatter()
        let query: Parameters = [
            "id": 1,
            "user_id": 1,
            "qr_string": "Iskalinov",
            "door_id": 3
        ]
        AF.request(url, method: .post, parameters: query).responseDecodable { (dataResponse: DataResponse<Result, AFError>) in
            switch dataResponse.result {
            case .success(let status):
                //                let list = wordList.list
                //                list.forEach { (word) in
                //                    print(word.word)
                //                }
                success(status)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func enter(userId: Int, qrCode: String, success: @escaping(Result2) -> (), failure: @escaping(AFError) -> ()) {
        guard let url = URL(string: "http://172.20.10.2:8000/api/send_qr/") else { return }
        print(url)
        let query: Parameters = [
            "user_id": userId,
            "qr_string": qrCode,
        ]
        print(userId)
        guard let access = CurrentUser.access else {
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
                failure(error)
            }
        }

    }
    
    
}
