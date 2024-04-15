//
//  LoginViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .systemYellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func bind() {
        <#code#>
    }
}
