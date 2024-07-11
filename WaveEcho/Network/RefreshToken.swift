//
//  RefreshToken.swift
//  WaveEcho
//
//  Created by 박지은 on 4/23/24.
//

import Foundation
import Alamofire

final class RefreshToken: RequestInterceptor {
    
    // adapt, retry 별도의 호출없이 생성만 해두면 자동으로 호출된다
    
    // 네트워크 호출을 할 때 서버로 보내기 전에 api를 가로채서 전처리를 한 뒤 서버에 보내는 역할
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        // let ➡️ var
        var urlRequest = urlRequest
        
        urlRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        completion(.success(urlRequest))
    }
    
    // adpat를 통해 보낸 API가 실패일 경우
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        switch statusCode {
            // 419: 액세스 토큰 만료 -> refresh 라우터를 통해 토큰 갱신
            // 418: 리프레시 토큰까지 만료 -> 로그인 뷰로 전환
        case 419:
            
            do {
                let urlRequest = try UsersRouter.refreshToken.asURLRequest()
                AF
                    .request(urlRequest)
                    .responseDecodable(of: RefreshTokenModel.self) { response in
                        
                        switch response.result {
                        case .success(let success):
                            // 재발급 성공 -> 새로운 토큰 저장
                            UserDefaultsManager.shared.accessToken = success.accessToken
                            completion(.retry) // ❗️
                        case .failure(let error):
                            // doNotRetryWithError 실행
                            completion(.doNotRetryWithError(error))
                        }
                    }
            }
            catch {
                
            }
        default:
            completion(.doNotRetry)
        }
    }
}
