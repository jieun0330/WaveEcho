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
    case editMyPofile(query: EditMyProfileRequestBody)
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        case .editMyPofile:
            return .put
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .myProfile:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .editMyPofile:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .myProfile, .editMyPofile:
            return "/v1/users/me/profile"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .myProfile:
            return nil
        case .editMyPofile(query: let query):
            return try? encoder.encode(query)
        }
    }
}
