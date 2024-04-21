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
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.allHTTPHeaderFields = headers
        
        if let parameters {
            if method == .get {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            } else {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        urlRequest.httpBody = body
        return urlRequest
    }
}
