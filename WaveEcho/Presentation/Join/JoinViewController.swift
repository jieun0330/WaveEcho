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

final class JoinViewController: BaseViewController {
    
    private let mainView = JoinView()
    private let viewModel = JoinViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func configureView() {
        mainView.nicknameTextField.delegate = self
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
    }
    
    override func uiBind() {
        
        // 로그인뷰 이동
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.navigationController?.viewControllers = [vc]
            }
            .disposed(by: disposeBag)
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
                let validButtonColor: UIColor = value ? .systemYellow : .systemGray5
                owner.mainView.signupButton.backgroundColor = validButtonColor
                let buttonTitleColor: UIColor = value ? .black : .lightGray
                owner.mainView.signupButton.setTitleColor(buttonTitleColor, for: .normal)
                let isEnabled: Bool = value ? true : false
                owner.mainView.signupButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        // 회원가입 완료 토스트 창
        output.signupTrigger
            .debounce(.seconds(1))
            .drive(with: self) { owner, _ in
                owner.view.makeToast("회원가입이 완료되었습니다")
            }
            .disposed(by: disposeBag)
        
        // 회원가입 완료 -> 로그인 뷰컨 이동
        output.signupTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.navigationController?.setViewControllers([vc], animated: true)
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
        
        // 이메일 중복 확인 에러 처리
        //        output.validEmailError
        //            .drive(with: self) { owner, error in
        //                owner.errorHandler(apiError: error, calltype: .validEmail)
        //            }
        //            .disposed(by: disposeBag)
        
        //        signupOutput.validSignup
        //            .drive(with: self) { owner, value in
        //                let validEmail: String = value ? "사용 가능한 이메일입니다" : "사용 불가한 이메일입니다"
        //                owner.mainView.validEmail.text = validEmail
        //            }.disposed(by: disposeBag)
    }
//    deinit {
//        print(self)
//    }
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
