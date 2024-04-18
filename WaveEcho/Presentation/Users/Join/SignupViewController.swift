//
//  JoinViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

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
        
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func bind() {
        let signupInput = SignupViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty,
                                                password: mainView.passwordTextField.rx.text.orEmpty,
                                                nickname: mainView.nicknameTextField.rx.text.orEmpty,
                                                signupButtonTapped: mainView.signupButton.rx.tap,
                                                validEmailButtonTapped: mainView.validEmailButton.rx.tap)
        
        let signupOutput = viewModel.transform(input: signupInput)
        
        signupOutput.validSignup
            .drive(with: self) { owner, value in
                let validButtonColor: UIColor = value ? .systemYellow : .systemGray5
                owner.mainView.signupButton.backgroundColor = validButtonColor
                let buttonTitleColor: UIColor = value ? .black : .lightGray
                owner.mainView.signupButton.setTitleColor(buttonTitleColor, for: .normal)
                let isEnabled: Bool = value ? true : false
                owner.mainView.signupButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        signupOutput.signupTrigger
            .drive(with: self) { owner, _ in
                owner.view.makeToast("회원가입이 완료되었습니다")
                print("회원가입 성공")
            }
            .disposed(by: disposeBag)
        
        signupOutput.validEmailTrigger
            .drive(with: self) { owner, _ in
                print("이메일 중복 검사 완료")
            }
            .disposed(by: disposeBag)
        
        signupOutput.validEmail
            .drive(with: self) { owner, value in
                owner.mainView.validEmail.text = value
            }
            .disposed(by: disposeBag)
    }
}
