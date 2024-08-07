//
//  WelcomeViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: BaseViewController {
    
    private let mainView = WelcomeView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        mainView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setVC(SignupViewController())
            }
            .disposed(by: disposeBag)
        
        mainView.loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setVC(LoginViewController())
            }
            .disposed(by: disposeBag)
    }
    deinit {
        print(self, "deinit")
    }
}
