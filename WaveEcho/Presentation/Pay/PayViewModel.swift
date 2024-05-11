//
//  PayViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class PayViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let paymentSuccess = PublishRelay<IamportResponse>()
    
    struct Input {
        let paymentSuccess: PublishRelay<IamportResponse>
    }
    
    struct Output {
        let payValidationSuccess: Driver<PayResponse>
        let payValidationError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let postData = PublishRelay<PostData>()
        let payValidationSuccess = PublishRelay<PayResponse>()
        let payValidationError = PublishRelay<APIError>()
        
        Observable.combineLatest(input.paymentSuccess, postData)
            .flatMap { result in
                let (iamportResponse, postData) = result
                let query = PaymentRequestBody(imp_uid: iamportResponse.imp_uid ?? "",
                                               post_id: postData.post_id,
                                               productName: "waveEcho",
                                               price: 100)
                return APIManager.shared.create(type: PayResponse.self,
                                                router: PayRouter.paymentsValidation(query: query))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    payValidationSuccess.accept(success)
                case .failure(let error):
                    payValidationError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(payValidationSuccess: payValidationSuccess.asDriver(onErrorJustReturn: PayResponse(success: false, imp_uid: "", merchant_uid: "", description: "", error_code: "")),
                      payValidationError: payValidationError.asDriver(onErrorJustReturn: .code500))
    }
}
