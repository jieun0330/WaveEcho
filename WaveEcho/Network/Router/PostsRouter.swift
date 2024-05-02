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
//    case userPost(query: PostQueryString, id: String)
    case userPost(id: String)
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
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .createPosts(_):
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .fetchPosts:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .uploadImage:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .userPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
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
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createPosts(_):
            nil
        case .uploadImage, .userPost(_):
            nil
        case .fetchPosts(let query):
            ["next": query.next,
             "limit": query.limit,
             "product_id": query.product_id]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .createPosts(query: let query):
            return try? encoder.encode(query)
        case .fetchPosts, .uploadImage, .userPost:
            return nil
        }
    }
}
