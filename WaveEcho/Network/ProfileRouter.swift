//
//  ProfileRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case myProfile
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .myProfile:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .myProfile:
            return "/v1/users/me/profile"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var body: Data? {
        return nil
    }
}
