//
//  Router.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import Foundation
import Alamofire

enum Router {
    case signUp(query: SignupRequestBody)
    case login(query: LoginRequestBody)
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
                .post
        case .login:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .login:
            return "/users/login"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .signUp:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .signUp(let query):
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
