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
    case validEmail(query: ValidRequestBody)
    case login(query: LoginRequestBody)
    case refreshToken
}

extension UsersResponse: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
            return .post
        case .validEmail:
            return .post
        case .login:
            return .post
        case .refreshToken:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .join:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .validEmail:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .refreshToken:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue: UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "/v1/users/join"
        case .validEmail:
            return "/v1/validation/email"
        case .login:
            return "/v1/users/login"
        case .refreshToken:
            return "/v1/auth/refresh"
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
        case .validEmail(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .refreshToken:
            return nil
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
    
    static func validEmail(query: ValidRequestBody) -> Single<ValidResponse> {
        return Single<ValidResponse>.create { single in
            do {
                let urlRequest = try UsersResponse.validEmail(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: ValidResponse.self) { response in
                        switch response.result {
                        case .success(let validEmail):
                            single(.success(validEmail))
                            print("이메일 중복 검사 완료", validEmail)
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
    
    static func refreshToken() -> Single<RefreshTokenResponse> {
        return Single<RefreshTokenResponse>.create { single in
//            do {
                let urlRequest = UsersResponse.refreshToken.urlRequest!
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: RefreshTokenResponse.self) { response in
                        switch response.result {
                        case .success(let refreshToken):
                            single(.success(refreshToken))
                            print("토큰 갱신 완료", refreshToken)
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
//            }
//            catch {
//                single(.failure(error))
//            }
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
                            print("로그인 성공", loginResponse)
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
