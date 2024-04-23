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
    case createPosts(query: PostsRequestBody)
    case fetchPosts(query: FetchPostQuery)
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
        }
    }
    
    var path: String {
        switch self {
        case .createPosts, .fetchPosts:
            return "/v1/posts"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createPosts:
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
        }
    }
}
