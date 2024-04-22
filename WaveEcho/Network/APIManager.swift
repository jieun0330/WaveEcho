//
//  APIManager.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func create<T: Decodable>(type: T.Type, router: UsersRouter) -> Single<Result<T, APIError>> {
    
        return Single<Result<T, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF
                    .request(urlRequest)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                        case .failure(_):
                            guard let statusCode = response.response?.statusCode else { return }
                            guard let error = APIError(rawValue: statusCode) else { return }
                            single(.success(.failure(error)))
                        }
                    }
            }
            catch {
                single(.success(.failure(APIError.code500)))
            }
            return Disposables.create()
        }
    }
}
