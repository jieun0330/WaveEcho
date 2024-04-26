//
//  APIManager.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func create<T: Decodable>(type: T.Type, router: TargetType) -> Single<Result<T, APIError>> {
    
        return Single<Result<T, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF
                    .request(urlRequest, interceptor: RefreshToken())
                    .responseDecodable(of: T.self) { response in
                        print("accessToken🤯", UserDefaults.standard.string(forKey: "accessToken"))
                        print("response🦄", response)
                        print("response.response?.statusCode 🆘", response.response?.statusCode)
                        switch response.result {
                        case .success(let success):
                            print("success💂🏻‍♀️", success)
                            single(.success(.success(success)))
                            
                        case .failure(_):
                            guard let statusCode = response.response?.statusCode else { return }
                            
                            // 418을 만났을 때의 화면전환 인데 
//                            if statusCode == 418 {
//                            }
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
    
//    func upload<T: Decodable>(type: T.type, router: TargetType) -> Single<Result<T, APIError>> {
//        
//        return Single<Result<T, APIError>>.create { single in
//            AF
//                .upload(multipartFormData: { multipartFormData in
//                    multipartFormData.append(<#T##data: Data##Data#>,
//                                             withName: <#T##String#>,
//                                             fileName: <#T##String?#>,
//                                             mimeType: <#T##String?#>)
//                }, to: router.baseURL.)
//        }
        
//    }
    
}
