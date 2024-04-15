//
//  UsersResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import Foundation
import Alamofire
import RxSwift

enum UsersResponse {
    case join(query: SignupRequestBody)
    case login(query: LoginRequestBody)
}

extension UsersResponse: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
            return .post
        case .login:
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .join:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "/v1/users/join"
        case .login:
            return "/v1/users/login"
        }
    }

    var parameters: String? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .join(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
}

extension UsersResponse {
    static func createJoin(query: SignupRequestBody) -> Single<JoinResponse> {
        return Single<JoinResponse>.create { single in
            do {
                let urlRequest = try UsersResponse.join(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: JoinResponse.self) { response in
                        switch response.result {
                        case .success(let joinResponse):
                            single(.success(joinResponse))
                            print("회원가입 완료", joinResponse)
                        case .failure(let error):
                            single(.failure(error))
//                            print("1", error)
//                            if response.response?.statusCode == 409 {
//                                print("이미 가입된 유저입니다")
//                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func createLogin(query: LoginRequestBody) -> Single<LoginResponse> {
        return Single<LoginResponse>.create { single in
            do {
                let urlRequest = try UsersResponse.login(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let loginResponse):
                            single(.success(loginResponse))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
