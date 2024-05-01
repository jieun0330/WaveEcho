//
//  KingFisherImage.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import Foundation
import Kingfisher

final class KingFisherNet: ImageDownloadRequestModifier {

    private let baseURL = APIKey.baseURL.rawValue
    private let version = "/v1/"

    func modified(for request: URLRequest) -> URLRequest? {

        var components = URLComponents(string: baseURL)
        components?.path = version + (request.url?.path() ?? "")

        guard let url = components?.url else { return nil }
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue(UserDefaults.standard.string(forKey: "accessToken") ?? "", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        urlRequest.addValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)

        return urlRequest
    }
}
