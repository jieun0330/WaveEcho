//
//  TargetType.swift
//  WaveEcho
//
//  Created by 박지은 on 4/12/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.allHTTPHeaderFields = headers
        
        if let parameters {
            // HTTP 메서드가 get인 경우, 파라미터를 URL의 쿼리 문자열로 인코딩
            if method == .get {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
                // 그 외의 경우, 파라미터를 JSON으로 인코딩하여 요청 본문에 설정
            } else {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        urlRequest.httpBody = body
        return urlRequest
    }
}
