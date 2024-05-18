//
//  ChatRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    // 채팅방 생성
    case makeChatRoom(query : ChatRequest)
}

extension ChatRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .makeChatRoom(_):
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .makeChatRoom(_):
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .makeChatRoom(_):
            return "v1/chats"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys

        switch self {
        case .makeChatRoom(query: let query):
            return nil
        }
    }
}
