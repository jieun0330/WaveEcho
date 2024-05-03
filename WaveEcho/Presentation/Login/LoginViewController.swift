//
//  LoginViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import Lottie

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func configureView() {
        
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
    }
    
    override func uiBind() {
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SignupViewController()
                owner.navigationController?.viewControllers = [vc]
            }
            .disposed(by: disposeBag)
        
        mainView.loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        
        let input = LoginViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                         password: mainView.passwordTextField.rx.text.orEmpty,
                                         loginButtonTapped: mainView.loginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        // 로그인버튼 (비)활성화
        output.validLogin.asObservable()
            .bind(with: self) { owner, value in
                let validButtonColor: UIColor = value ? .systemCyan : .systemGray5
                owner.mainView.loginButton.backgroundColor = validButtonColor
                let buttonTitleColor: UIColor = value ? .black : .lightGray
                owner.mainView.loginButton.setTitleColor(buttonTitleColor, for: .normal)
                let status: Bool = value ? true : false
                owner.mainView.loginButton.isEnabled = status
            }
            .disposed(by: disposeBag)
        
        // 로그인 실패했을 시 에러 핸들링
        output.loginError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .login)
            }
            .disposed(by: disposeBag)
        
        // 로그인 되었습니다 toast message
        output.loginTrigger
            .drive(with: self) { owner, value in
                owner.view.makeToast("로그인되었습니다")
            }
            .disposed(by: disposeBag)
        
        // 2초 후 화면 전환
        output.loginTrigger
            .debounce(.seconds(1))
            .drive(with: self) { owner, _ in
                let vc = PostsViewController()
                owner.navigationController?.setViewControllers([vc], animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == mainView.emailTextField {
            mainView.passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
