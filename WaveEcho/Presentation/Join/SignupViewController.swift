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

final class SignupViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private let mainView = SignupView()
    private let viewModel = SignupViewModel()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
        
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.navigationController?.viewControllers = [vc]
            }
            .disposed(by: disposeBag)
        
        mainView.nicknameTextField.delegate = self
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
    }
    
    override func bind() {
        let input = SignupViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                                password: mainView.passwordTextField.rx.text.orEmpty,
                                                nickname: mainView.nicknameTextField.rx.text.orEmpty,
                                                signupButtonTapped: mainView.signupButton.rx.tap,
                                                validEmailButtonTapped: mainView.validEmailButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
        
        output.signupTrigger
            .drive(with: self) { owner, _ in
                print("회원가입 성공")
                owner.view.makeToast("회원가입이 완료되었습니다")
            }
            .disposed(by: disposeBag)
        
        output.signupTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                let vc = PostsViewController()
                owner.navigationController?.setViewControllers([vc], animated: true)
            }
            .disposed(by: disposeBag)
        
        output.validEmailTrigger
            .drive(with: self) { owner, _ in
                print("이메일 중복 검사 완료")
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
        output.validEmailError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .validEmail)
            }
            .disposed(by: disposeBag)
        
//        signupOutput.validSignup
//            .drive(with: self) { owner, value in
//                let validEmail: String = value ? "사용 가능한 이메일입니다" : "사용 불가한 이메일입니다"
//                owner.mainView.validEmail.text = validEmail
//            }.disposed(by: disposeBag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.nicknameTextField {
            self.mainView.emailTextField.becomeFirstResponder()
        } else if textField == self.mainView.emailTextField {
            self.mainView.passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
    }
}
