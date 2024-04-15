//
//  JoinViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignupViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let signupButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let signupTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let signupTrigger = PublishRelay<Void>()
        
        let signupObservable = Observable.combineLatest(input.email,
                                                      input.password, input.nickname)
            .map { email, password, nickname in
                return SignupRequestBody(email: email,
                                       password: password,
                                       nick: nickname,
                                       phoneNum: nil,
                                       birthDay: nil)
            }
        
        input.signupButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signupObservable)
            .flatMap { joinRequest in
                return UsersResponse.createJoin(query: joinRequest)
            }
            .subscribe(with: self) { owner, joinResponse in
                UserDefaults.standard.set(joinResponse.email, forKey: "email")
                signupTrigger.accept(())
            }
            .disposed(by: disposeBag)
                
        return Output(signupTrigger: signupTrigger.asDriver(onErrorJustReturn: ()))
    }
}
