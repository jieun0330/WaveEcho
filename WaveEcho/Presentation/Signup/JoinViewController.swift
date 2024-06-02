//
//  SignupViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import SnapKit

final class JoinViewController: BaseViewController {
    
    private let mainView = SignupView()
    private let viewModel = JoinViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인 화면 이동
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func configureView() {
        mainView.nicknameTextField.delegate = self
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
    }
    
    override func bind() {
        
        let input = JoinViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                        password: mainView.passwordTextField.rx.text.orEmpty,
                                        nickname: mainView.nicknameTextField.rx.text.orEmpty,
                                        signupButtonTapped: mainView.signupButton.rx.tap,
                                        validEmailButtonTapped: mainView.validEmailButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        // 회원가입 조건
        output.validSignup
            .drive(with: self) { owner, value in
                owner.validButton(value, button: owner.mainView.signupButton)
            }
            .disposed(by: disposeBag)
        
        // 회원가입 완료 토스트 창
        output.signupSuccess
            .debounce(.seconds(1))
            .drive(with: self) { owner, _ in
                owner.view.makeToast("회원가입이 완료되었습니다", duration: 1)
            }
            .disposed(by: disposeBag)
        
        // 회원가입 완료 -> 로그인 뷰컨 이동
        output.signupSuccess
            .debounce(.seconds(1))
            .drive(with: self) { owner, _ in
                owner.setVC(vc: LoginViewController())
            }
            .disposed(by: disposeBag)
        
        output.validEmailTrigger
            .drive(with: self) { owner, _ in
                owner.mainView.validEmail.isHidden = false
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복확인 안내 text
        output.validEmail
            .drive(with: self) { owner, value in
                owner.mainView.validEmail.text = value
            }
            .disposed(by: disposeBag)
        
        // 회원가입 에러 처리
        output.signupError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .signup)
            }
            .disposed(by: disposeBag)
                
        // 로그인뷰 이동
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.setVC(vc: LoginViewController())
            }
            .disposed(by: disposeBag)
    }
    deinit {
        print(self, "deinit")
    }
}

extension JoinViewController: UITextFieldDelegate, UITextViewDelegate {
    
    // 입력 완료 후 다음 텍스트필드 커서로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.nicknameTextField {
            self.mainView.emailTextField.becomeFirstResponder()
        } else if textField == self.mainView.emailTextField {
            self.mainView.passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mainView.nicknameTextField {
            let transform = CGAffineTransform(translationX: 0, y: -150)
            mainView.transform = transform
        }
        
        if textField == mainView.emailTextField {
            let transform = CGAffineTransform(translationX: 0, y: -120)
            mainView.transform = transform
        }
        
        if textField == mainView.passwordTextField {
            let transform = CGAffineTransform(translationX: 0, y: -100)
            mainView.transform = transform
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mainView.passwordTextField {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            mainView.transform = transform
        }
    }
}
