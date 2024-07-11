//
//  PayManager.swift
//  WaveEcho
//
//  Created by 박지은 on 7/11/24.
//

import Foundation
import RxSwift
import Alamofire
import iamport_ios
import WebKit

final class PayManager {
    
    static let shared = PayManager()
    
    private init() { }
    
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
