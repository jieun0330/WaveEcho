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
    // 댓글 삭제
    case deleteComment(postID: String, commentID: String)
}

extension CommentRouter: TargetType {

    var method: Alamofire.HTTPMethod {
        switch self {
        case .writeComment:
            return .post
        case .deleteComment(_, _):
            return .delete
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .writeComment:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .deleteComment(_, _):
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .writeComment(_, id: let id):
            return "/v1/posts/\(id)/comments"
        case .deleteComment(postID: let postID, commentID: let commentID):
            return "/v1/posts/\(postID)/comments/\(commentID)"
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
        case .deleteComment(_, _):
            return nil
        }
    }
}
