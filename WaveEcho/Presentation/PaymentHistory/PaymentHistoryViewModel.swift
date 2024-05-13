//
//  PaymentHistoryViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PaymentHistoryViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Bool>
    }
    
    struct Output {
        let payHistorySuccess: Driver<PayHistoryModel>
        let payHistoryError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let payHistorySuccess = PublishRelay<PayHistoryModel>()
        let payHistoryError = PublishRelay<APIError>()
        
        input.viewWillAppearTrigger
            .flatMapLatest { _ in
                APIManager.shared.create(type: PayHistoryModel.self, router: PayRouter.paymentHistory)
            }
            .bind(with: self) { owner, result in
                print("1️⃣", result)
                switch result {
                case .success(let success):
                    payHistorySuccess.accept(success)
                case .failure(let error):
                    payHistoryError.accept(error)
                }
            }
            .disposed(by: disposeBag)

        return Output(payHistorySuccess: payHistorySuccess.asDriver(onErrorJustReturn: PayHistoryModel(payment_id: "", buyer_id: "", post_id: "", merchant_uid: "", productName: "", price: 0, paidAt: "")), payHistoryError: payHistoryError.asDriver(onErrorJustReturn: .code500))
    }
}
