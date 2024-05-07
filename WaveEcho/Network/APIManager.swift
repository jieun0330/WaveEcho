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
                        print("response", response)
                        switch response.result {
                        case .success(let success):
                            print("success", success)
                            single(.success(.success(success)))
                        case .failure(let error):
                            print("error", error.localizedDescription)
                            guard let statusCode = response.response?.statusCode else { return }
                            guard let error = APIError(rawValue: statusCode) else { return }
                            print("statusCode", statusCode)
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
    
    func upload<T: Decodable>(type: T.Type, router: TargetType, image: Data) -> Single<Result<T, APIError>> {
        
        return Single<Result<T, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(image,
                                                 withName: "files",
                                                 fileName: "test.png",
                                                 mimeType: "image/png")
                    }, with: urlRequest, interceptor: RefreshToken())
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
                
            }
            return Disposables.create()
        }
    }
    
//    func editProfile<T: Decodable>(type: T.Type, router: TargetType, model: EditMyProfileResponse) -> Single<Result<T, APIError>> {
//        
//        return Single<Result<T, APIError>>.create { single in
//            do {
//                let urlRequest = try router.asURLRequest()
//                AF
//                    .upload(multipartFormData: { multipartFormData in
//                        
//                        if let nickname = model.nick.data(using: .utf8) {
//                            multipartFormData.append(nickname, withName: "nickname")
//                        }
//                        
//                        if let profileImage = model.profileImage {
//                            multipartFormData.append(profileImage,
//                                                     withName: "files",
//                                                     fileName: "test.png",
//                                                     mimeType: "image/png")
//                        }
//                        
//                        
////                        multipartFormData.append(image,
////                                                 withName: "files",
////                                                 fileName: "test.png",
////                                                 mimeType: "image/png")
//                    }, with: urlRequest, interceptor: RefreshToken())
//                    .responseDecodable(of: T.self) { response in
//                        switch response.result {
//                        case .success(let success):
//                            single(.success(.success(success)))
//                        case .failure(_):
//                            guard let statusCode = response.response?.statusCode else { return }
//                            guard let error = APIError(rawValue: statusCode) else { return }
//                            single(.success(.failure(error)))
//                        }
//                    }
//            }
//            catch {
//                
//            }
//            return Disposables.create()
//        }
//    }
}
