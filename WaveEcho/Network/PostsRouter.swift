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
    // 포스트 작성
    case createPosts(query: PostsRequestBody)
    // 포스트 조회
    case fetchPosts(query: FetchPostQuery)
    // 포스트 이미지 업로드
    case uploadImage(query: ImageUploadRequestBody)
}

extension PostsRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createPosts:
            return .post
        case .fetchPosts:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .createPosts:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .fetchPosts:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .uploadImage:
            return [HTTPHeader.authorization.rawValue: accessToken,
                    HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .createPosts, .fetchPosts:
            return "/v1/posts"
        case .uploadImage:
            return "/v1/posts/files"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createPosts, .uploadImage:
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
        case .fetchPosts:
            return nil
        case .uploadImage(query: let query):
            return try? encoder.encode(query)
        }
    }
}
