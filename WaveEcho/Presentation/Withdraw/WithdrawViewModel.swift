//
//  WithdrawViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WithdrawViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let withdrawButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let withdrawSuccess: Driver<WithdrawResponse>
        let withdrawError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let withdrawSuccess = PublishRelay<WithdrawResponse>()
        let withdrawError = PublishRelay<APIError>()
        
        input.withdrawButtonTapped
            .flatMap { _ in
                return APIManager.shared.create(type: WithdrawResponse.self, router: UsersRouter.withdraw)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    withdrawSuccess.accept(success)
                case .failure(let error):
                    withdrawError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(withdrawSuccess: withdrawSuccess.asDriver(onErrorJustReturn: WithdrawResponse(user_id: "", email: "", nick: "")), withdrawError: withdrawError.asDriver(onErrorJustReturn: .code500))
    }
}
