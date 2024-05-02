//
//  CommentRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation
import Alamofire

enum CommentRouter {
    // 댓글 작성
    case writeComment(query: WriteCommentRequestBody, id: String)
}

extension CommentRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .writeComment:
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .writeComment:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .writeComment(_, id: let id):
            return "/v1/posts/\(id)/comments"
        }
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys

        switch self {
        case .writeComment(query: let query, _):
            return try? encoder.encode(query)
        }
    }
}
