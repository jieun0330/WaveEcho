//
//  WelcomeViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit

final class WelcomeViewController: BaseViewController {
    
    private let mainView = WelcomeView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        mainView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        print(#function)
        let vc = SignupViewController()
        navigationController?.viewControllers = [vc]

    }
    
    @objc private func loginButtonTapped() {
        print(#function)
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
