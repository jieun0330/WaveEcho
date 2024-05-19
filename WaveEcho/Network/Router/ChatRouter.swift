//
//  ChatRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    // 내 채팅방 리스트 조회
    case myChatList
}

extension ChatRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myChatList:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .myChatList:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .myChatList:
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
        case .myChatList:
            return nil
        }
    }
}
