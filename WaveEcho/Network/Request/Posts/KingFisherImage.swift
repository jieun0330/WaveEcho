//
//  KingFisherImage.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import Foundation
import Kingfisher

// 헤더, 토큰, 특정 URL 변경 등의 상황에 대처할 수 있는 기능
final class KingFisherNet: ImageDownloadRequestModifier {

    private let baseURL = APIKey.baseURL.rawValue
    private let version = "/v1/"

    func modified(for request: URLRequest) -> URLRequest? {

        // URLComponents 조립
        // baseURL
        var components = URLComponents(string: baseURL)
        // path
        components?.path = version + (request.url?.path() ?? "")

        // URL 변환
        guard let url = components?.url else { return nil }
        // URL Request 변환
        var urlRequest = URLRequest(url: url)

        // 헤더 추가
        urlRequest.addValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        // 키 추가
        urlRequest.addValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)

        return urlRequest
    }
}
