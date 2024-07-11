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
    
    // 네트워크 통신 직전에 호출되며, adapt 내부에서 토큰 값을 헤더에 주입한다
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        urlRequest.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        completion(.success(urlRequest))
    }
    
    // adpat를 통해 보낸 API가 실패일 경우
    // 토큰의 유효기간이 끝나 인증 실패로 Error가 반환되었을 경우, retry 내부에서 토큰을 갱신받고 재요청한다
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        // 상태코드가 없을 경우(클라이언트 잘못)
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
                            // 재시도 요청
                            completion(.retry)
                        case .failure(let error):
                            // 재시도하지않고 종료 및 error 반환
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
