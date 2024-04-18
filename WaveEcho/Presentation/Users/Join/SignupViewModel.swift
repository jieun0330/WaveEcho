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
        let validEmailButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        // 회원가입 조건
        let validSignup: Driver<Bool>
        // 회원가입
        let signupTrigger: Driver<Void>
        // 이메일 중복 확인
        let validEmailTrigger: Driver<Bool>
        let validEmail: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        //회원가입 조건
        let validSignup = BehaviorRelay(value: false)
        // 회원가입
        let signupTrigger = PublishRelay<Void>()
        // 이메일 중복 확인
        let validEmailTrigger = PublishRelay<Bool>()
        let validEmail = BehaviorRelay(value: "")
                
        let signupObservable = Observable.combineLatest(input.email,
                                                        input.password,
                                                        input.nickname)
            .map { email, password, nickname in
                return SignupRequestBody(email: email,
                                       password: password,
                                       nick: nickname,
                                       phoneNum: nil,
                                       birthDay: nil)
            }
        
        // 회원가입 조건
        signupObservable
            .bind(with: self) { owner, signupRequest in
                if signupRequest.nick.count >= 2 &&
                    signupRequest.email.contains("@") &&
                    signupRequest.email.contains(".com") &&
                    signupRequest.password.count >= 8 {
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
            .flatMap { joinRequest in
                return UsersRouter.createJoin(query: joinRequest)
            }
            .subscribe(with: self) { owner, joinResponse in
                UserDefaults.standard.set(joinResponse.email, forKey: "email")
                signupTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복 확인
        input.validEmailButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .flatMap { email in
                UsersRouter.validEmail(query: ValidRequestBody(email: email))
            }
            .bind(with: self) { owner, validEmailResponse in
                validEmailTrigger.accept(true)
                //  이메일 중복 확인 응답코드 description
                validEmail.accept(validEmailResponse.message)
            }
            .disposed(by: disposeBag)
               
        return Output(validSignup: validSignup.asDriver(),
                      signupTrigger: signupTrigger.asDriver(onErrorJustReturn: ()),
                      validEmailTrigger: validEmailTrigger.asDriver(onErrorJustReturn: true),
                      validEmail: validEmail.asDriver())
        
    }
}
