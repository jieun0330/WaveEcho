//
//  JoinViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController {
    
    private let mainView = SignupView()
    private let viewModel = SignupViewModel()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func bind() {
        let signupInput = SignupViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                                password: mainView.passwordTextField.rx.text.orEmpty,
                                                nickname: mainView.nicknameTextField.rx.text.orEmpty,
                                                signupButtonTapped: mainView.signupButton.rx.tap)
        
        let signupOutput = viewModel.transform(input: signupInput)
        
        signupOutput.signupTrigger
            .drive(with: self) { owner, value in
                print("회원가입 성공")
            }
            .disposed(by: disposeBag)
    }
}
