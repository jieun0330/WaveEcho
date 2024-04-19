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

class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .systemYellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
        
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SignupViewController()
//                owner.navigationController?.pushViewController(vc, animated: true)
                owner.navigationController?.viewControllers = [vc]
            }
            .disposed(by: disposeBag)
        
//        mainView.loginButton.rx.tap
//            .bind(with: self) { owner, _ in
//                let vc = PostsViewController()
//                owner.navigationController?.pushViewController(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let loginInput = LoginViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                              password: mainView.passwordTextField.rx.text.orEmpty,
                                              loginButtonTapped: mainView.loginButton.rx.tap)
        
        let loginOutput = viewModel.transform(input: loginInput)
        
        loginOutput.validLogin.asObservable()
            .bind(with: self) { owner, value in
                let status: Bool = value ? true : false
                owner.mainView.loginButton.isEnabled = status
            }
            .disposed(by: disposeBag)
        
        loginOutput.loginTrigger
            .drive(with: self) { owner, value in
                print("로그인 성공")
                owner.view.makeToast("로그인되었습니다")
            }
            .disposed(by: disposeBag)
        
        loginOutput.loginTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                let vc = PostsViewController()
                owner.navigationController?.setViewControllers([vc], animated: true)
            }
            .disposed(by: disposeBag)
    }
}
