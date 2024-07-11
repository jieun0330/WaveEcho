//
//  APIManager.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

import Foundation
import RxSwift
import Alamofire

struct APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func create<T: Decodable>(type: T.Type, router: TargetType) -> Single<Result<T, APIError>> {
        
        return Single<Result<T, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .request(urlRequest, interceptor: RefreshToken())
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
    
    func upload<T: Decodable>(type: T.Type, router: TargetType, image: Data) -> Single<Result<T, APIError>> {
        
        return Single<Result<T, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(image,
                                                 withName: "files", // key값
                                                 fileName: "test.png", // 파일 이름
                                                 mimeType: "image/png") // 이미지 형식
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
    
    func uploadProfile(query: EditMyProfileRequestBody) -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.editMyPofile(query: query).asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
            
                    multipartFormData.append(query.profile!,
                                             withName: "profile", // key값
                                             fileName: "sesac.png", // 파일 이름
                                             mimeType: "image/png") // 이미지 형식
                    
                    if let stringData = query.nick.data(using: .utf8) {
                           multipartFormData.append(stringData, withName: "nick")
                       }
                }, with: urlRequest, interceptor: RefreshToken())
                .responseDecodable(of: ProfileModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        print(success)
                        single(.success(success))
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
