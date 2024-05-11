//
//  PayRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 5/9/24.
//

import Foundation
import Alamofire

enum PayRouter {
    // 결제 영수증 검증
    case paymentsValidation(query: PaymentRequestBody)
}

extension PayRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .paymentsValidation(_):
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .paymentsValidation(_):
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .paymentsValidation(_):
            return "v1/payments/validation"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys

        switch self {
        case .paymentsValidation(query: let query):
            return try? encoder.encode(query)
        }
    }
}
