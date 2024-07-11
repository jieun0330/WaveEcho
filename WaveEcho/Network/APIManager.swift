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
import iamport_ios
import WebKit

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
    
    func uploadProfile(query: EditMyProfileRequestBody) -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.editMyPofile(query: query).asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
            
                    multipartFormData.append(query.profile!,
                                                 withName: "profile",
                                                 fileName: "sesac.png",
                                                 mimeType: "image/png")
                    
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
    
    func pay(amount: String, productTitle: String, webView: WKWebView, completionHandler: @escaping (IamportResponse?) -> Void) {
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
            amount: amount).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = productTitle // 결제할 상품명
                $0.buyer_name = "박지은" // 관리자 페이지 주문자 이름
                $0.app_scheme = "waveEcho" // App Scheme 정보
            }
        
        Iamport.shared.paymentWebView(webViewMode: webView,
                                      userCode: APIKey.userCode.rawValue,
                                      payment: payment,
                                      paymentResultCallback: completionHandler)
    }
    
    func paymentValidation(router: TargetType) -> Single<Result<Void, APIError>> {
        return Single<Result<Void, APIError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .request(urlRequest, interceptor: RefreshToken())
                    .response { response in
                        switch response.result {
                        case .success(_):
                            single(.success(.success(())))
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
