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

    override func uiBind() {
        mainView.signUpButton.rx.tap
            .debug()
            .bind(with: self) { owner, _ in
                let vc = JoinViewController()
                owner.navigationController?.viewControllers = [vc]
            }
            .disposed(by: disposeBag)
        
        mainView.loginButton.rx.tap
            .debug()
            .bind(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.navigationController?.setViewControllers([vc], animated: true)
            }
            .disposed(by: disposeBag)
    }
    deinit {
        print(self)
    }
}
