//
//  UsersResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import UIKit
import Alamofire
import RxSwift

enum UsersRouter {
    case signup(query: UserModel)
    case validEmail(query: ValidEmailRequestBody)
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
        case .signup, .validEmail, .login:
            return .post
        case .refreshToken, .withdraw:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .signup, .validEmail, .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .refreshToken:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue: UserDefaultsManager.shared.refreshToken]
        case .withdraw:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .signup:
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
        case .signup(query: let query):
            return try? encoder.encode(query)
        case .validEmail(query: let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        case .refreshToken, .withdraw:
            return nil
        }
    }
}
