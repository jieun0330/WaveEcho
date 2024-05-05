//
//  PostsRouter.swift
//  WaveEcho
//
//  Created by 박지은 on 4/18/24.
//

import UIKit
import Alamofire
import RxSwift

enum PostsRouter {
    // 포스트 이미지 업로드
    case uploadImage
    // 포스트 작성
    case createPosts(query: WritePostsRequestBody)
    // 포스트 조회
    case fetchPosts(query: PostQueryString)
    // 유저별 작성한 포스트 조회
    case userPost(id: String)
    // 포스트 삭제
    case delePost(id: String)
}

extension PostsRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createPosts(_):
            return .post
        case .fetchPosts:
            return .get
        case .uploadImage:
            return .post
        case .userPost:
            return .get
        case .delePost(_):
            return .delete
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .createPosts(_):
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .fetchPosts:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .uploadImage:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .userPost:
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .delePost(_):
            return [HTTPHeader.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .createPosts(_):
            return "/v1/posts"
        case .fetchPosts:
            return "/v1/posts"
        case .uploadImage:
            return "/v1/posts/files"
        case .userPost(id: let id):
            return "/v1/posts/users/\(id)"
        case .delePost(id: let id):
            return "/v1/posts/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createPosts(_), .delePost(_):
            nil
        case .uploadImage, .userPost(_):
            nil
        case .fetchPosts(let query):
            ["next": query.next,
             "limit": query.limit,
             "product_id": "신디"]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .createPosts(query: let query):
            return try? encoder.encode(query)
        case .fetchPosts, .uploadImage, .userPost, .delePost(_):
            return nil
        }
    }
}
