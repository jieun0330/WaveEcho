//
//  SignupViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let signupButtonTapped: ControlEvent<Void>
        let validEmailButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        // 회원가입 조건
        let validSignup: Driver<Bool>
        // 회원가입
        let signupTrigger: Driver<Void>
        // 이메일 중복 확인
        let validEmailTrigger: Driver<Bool>
        // 이메일 중복확인 안내 텍스트
        let validEmail: Driver<String>
        // 회원가입 에러처리
        let signupError: Driver<APIError>
        let validEmailError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        //회원가입 조건
        let validSignup = BehaviorRelay(value: false)
        // 회원가입
        let signupTrigger = PublishRelay<Void>()
        // 이메일 중복 확인
        let validEmailTrigger = PublishRelay<Bool>()
        // 이메일 중복확인 안내 텍스트
        let validEmail = BehaviorRelay(value: "")
        // 회원가입 에러처리
        let signupError = PublishRelay<APIError>()
        let validEmailError = PublishRelay<APIError>()
                
        let signupObservable = Observable.combineLatest(input.email,
                                                        input.password,
                                                        input.nickname)
            .map { email, password, nickname in
                return UserModel(email: email,
                                 password: password,
                                 nick: nickname,
                                 profile: nil)
            }
        
        let validEmailObservable = input.email.asObservable()
            .map { email in
                return ValidEmailRequestBody(email: email)
            }
        
        // 회원가입 조건
        signupObservable
            .debug()
            .bind(with: self) { owner, signupRequest in
                if signupRequest.nick.count >= 2 &&
                    signupRequest.email.contains("@") &&
                    signupRequest.email.contains(".com") &&
                    signupRequest.password.count >= 4
                {
                    validSignup.accept(true)
                } else {
                    validSignup.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        // 회원가입
        input.signupButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signupObservable)
            .flatMap { signupRequest in
                return APIManager.shared.create(type: SignupResponse.self, router: UsersRouter.signup(query: signupRequest))
            }
            .debug()
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.shared.email = success.email
                    UserDefaultsManager.shared.nickname = success.nick
                    signupTrigger.accept(())
                case .failure(let error):
                    signupError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복 확인
        input.validEmailButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(validEmailObservable)
            .flatMap { emailRequest in
                return APIManager.shared.create(type: ValidEmailResponse.self,
                                                router: UsersRouter.validEmail(query: emailRequest))
            }
            .debug()
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    validEmailTrigger.accept(true)
                    // 이메일 중복확인 안내 텍스트
                case .failure(let error):
                    validEmailError.accept(error)
                }
            }
            .disposed(by: disposeBag)
               
        return Output(validSignup: validSignup.asDriver(),
                      signupTrigger: signupTrigger.asDriver(onErrorJustReturn: ()),
                      validEmailTrigger: validEmailTrigger.asDriver(onErrorJustReturn: true),
                      validEmail: validEmail.asDriver(),
                      signupError: signupError.asDriver(onErrorJustReturn: .code500),
                      validEmailError: validEmailError.asDriver(onErrorJustReturn: .code500))
    }
}
