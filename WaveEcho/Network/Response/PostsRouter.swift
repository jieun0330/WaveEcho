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
}

extension PostsRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .posts:
            return .post
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .posts:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/v1/posts"
        }
    }

    var parameters: String? {
        return nil
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        switch self {
        case .posts(query: let query):
            return try? encoder.encode(query)
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
}
