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
                print("2번", urlRequest)
                AF
                    .request(urlRequest, interceptor: RefreshToken())
                    .responseDecodable(of: T.self) { response in
                        print("3버", response)
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
    
    func editProfile(query: EditMyProfileRequestBody) -> Single<Result<EditMyProfileResponse, APIError>> {
        
        return Single<Result<EditMyProfileResponse, APIError>>.create { single in
            do {
                let urlRequest = try ProfileRouter.editMyPofile(query: query).asURLRequest()
                
                AF
                    .upload(multipartFormData: { multipartFormData in
                        
                        if let profile = query.profile {
                            multipartFormData.append(profile,
                                                     withName: "files",
                                                     fileName: "test.png",
                                                     mimeType: "image/png")
                        }
                    }, with: urlRequest, interceptor: RefreshToken())
                    .responseDecodable(of: EditMyProfileResponse.self) { response in
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
}
