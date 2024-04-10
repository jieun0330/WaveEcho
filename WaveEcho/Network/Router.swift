//
//  Router.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import Foundation
import Moya

enum Router {
    case login(query: LoginQuery)
}

extension Router: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.baseURL.rawValue)!
    }
    
    var path: String {
        switch self {
        case .login(let query):
            return "user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(let query):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let query):
            <#code#>
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let query):
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
}
