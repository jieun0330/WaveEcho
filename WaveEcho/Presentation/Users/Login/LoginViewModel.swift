//
//  LoginViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let loginTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let loginTrigger = PublishRelay<Void>()
        
        let loginObservable = Observable.combineLatest(input.email, input.password)
            .map { email, password in
                return LoginRequestBody(email: email, password: password)
            }
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { loginRequest in
                return UsersRouter.createLogin(query: loginRequest)
            }
            .bind(with: self) { owner, loginResponse in
                UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                loginTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(loginTrigger: loginTrigger.asDriver(onErrorJustReturn: ()))
    }
}
