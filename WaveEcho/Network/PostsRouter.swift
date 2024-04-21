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
    case posts(query: PostsRequestBody)
    case fetchPosts(query: FetchPostQuery)
}

extension PostsRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .posts:
            return .post
        case .fetchPosts:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .posts:
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
        case .posts, .fetchPosts:
            return "/v1/posts"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .posts:
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
        case .posts(query: let query):
            return try? encoder.encode(query)
        case .fetchPosts:
            return nil
        }
    }
}

extension PostsRouter {
    static func createPosts(query: PostsRequestBody) -> Single<PostsResponse> {
        return Single<PostsResponse>.create { single in
            do {
                let urlRequest = try PostsRouter.posts(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: PostsResponse.self) { response in
                        switch response.result {
                        case .success(let postsResponse):
                            single(.success(postsResponse))
                            print("포스팅 작성 성공", postsResponse)
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func fetchPosts(query: FetchPostQuery) -> Single<Result<FetchPostsResponse, APIError>> {
        return Single<Result<FetchPostsResponse, APIError>>.create { single in
            do {
                
                let urlRequest = try PostsRouter.fetchPosts(query: query).asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: FetchPostsResponse.self) { response in
                        switch response.result {
                        case .success(let fetchPostsResponse):
                            print("포스팅 조회 성공", fetchPostsResponse)
                            single(.success(.success(fetchPostsResponse)))
                        case .failure(let error):
                            guard let statusCode = response.response?.statusCode else { return }
                            guard let error = APIError(rawValue: statusCode) else { return }
                            single(.success(.failure(error)))
                        }
                    }
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
