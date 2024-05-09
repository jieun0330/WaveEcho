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
        // 로그인 조건
        let validLogin: Driver<Bool>
        // 로그인
        let loginTrigger: Driver<Void>
        // 에러처리
        let loginError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        // 로그인 조건
        let validLogin = BehaviorRelay(value: false)
        // 로그인
        let loginTrigger = PublishRelay<Void>()
        // 에러 처리
        let loginError = PublishRelay<APIError>()
        
        let loginObservable = Observable.combineLatest(input.email, input.password)
            .map { email, password in
                return LoginRequestBody(email: email, password: password)
            }
        
        // 로그인 조건
        loginObservable
            .bind(with: self) { owner, loginRequest in
                if loginRequest.email.contains("@") && loginRequest.email.contains(".com") && loginRequest.password.count > 3 {
                    validLogin.accept(true)
                } else {
                    validLogin.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .debug()
            .flatMap { loginRequest in
                return APIManager.shared.create(type: LoginResponse.self,
                                                router: UsersRouter.login(query: loginRequest))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.shared.accessToken = success.accessToken
                    UserDefaultsManager.shared.refreshToken = success.refreshToken
                    UserDefaultsManager.shared.userID = success.user_id
                    UserDefaultsManager.shared.sendPost = 5
                    loginTrigger.accept(())
                case .failure(let error):
                    loginError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(validLogin: validLogin.asDriver(),
                      loginTrigger: loginTrigger.asDriver(onErrorJustReturn: ()),
                      loginError: loginError.asDriver(onErrorJustReturn: .code500))
    }
}
