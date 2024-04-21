//
//  UsersResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import UIKit
import Alamofire
import RxSwift

let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""

enum UsersRouter {
    case join(query: SignupRequestBody)
    case validEmail(query: ValidRequestBody)
    case login(query: LoginRequestBody)
    case refreshToken
    case withdraw
}

extension UsersRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join, .validEmail, .login:
            return .post
        case .refreshToken, .withdraw:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .join, .validEmail, .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .refreshToken:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue: UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
        case .withdraw:
            return [:]
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
        case .withdraw:
            return "/v1/users/withdraw"
        }
    }

    var parameters: [String: Any]? {
        nil
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        switch self {
        case .join(query: let query):
            return try? encoder.encode(query)
        case .validEmail(query: let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        case .refreshToken:
            return nil
        case .withdraw:
            return nil
        }
    }
}

extension UsersRouter {
    static func createJoin(query: SignupRequestBody) -> Single<JoinResponse> {
        return Single<JoinResponse>.create { single in
            do {
                let urlRequest = try UsersRouter.join(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: JoinResponse.self) { response in
                        switch response.result {
                        case .success(let joinResponse):
                            single(.success(joinResponse))
                            print("회원가입 완료", joinResponse)
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // 이메일 중복 확인
    static func validEmail(query: ValidRequestBody) -> Single<ValidResponse> {
        return Single<ValidResponse>.create { single in
            do {
                let urlRequest = try UsersRouter.validEmail(query: query).asURLRequest()
                
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
                let urlRequest = UsersRouter.refreshToken.urlRequest!
                
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
            return Disposables.create()
        }
    }
    
    // 로그인
    static func createLogin(query: LoginRequestBody) -> Single<Result<LoginResponse, APIError>> {
        return Single<Result<LoginResponse, APIError>>.create { single in
            do {
                let urlRequest = try UsersRouter.login(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let loginResponse):
                            single(.success(.success(loginResponse)))
                            print("로그인 성공", loginResponse)
                        case .failure(let error):
                            guard let statusCode = response.response?.statusCode else { return }
                            guard let error = APIError(rawValue: statusCode) else { return }
                            single(.success(.failure(error)))
                        }
                    }
            }
            catch {
                single(.success(.failure(APIError.code400)))
            }
            return Disposables.create()
        }
    }
        
    static func withdrawUsers() -> Single<WithdrawResponse> {
        return Single<WithdrawResponse>.create { single in
            let urlRequest = UsersRouter.withdraw.urlRequest!
            
            AF
                .request(urlRequest)
                .responseDecodable(of: WithdrawResponse.self) { response in
                    switch response.result {
                    case .success(let withdrawResponse):
                        single(.success(withdrawResponse))
                        print("회원탈퇴 성공", withdrawResponse)
                    case .failure(let error):
                        single(.failure(error))
                        print(error)
                    }
                }
            return Disposables.create()
        }
    }
}
