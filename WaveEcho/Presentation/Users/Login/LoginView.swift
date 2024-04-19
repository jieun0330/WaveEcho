//
//  LoginView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit

class LoginView: BaseView {
    
    private let login = {
        let signUp = UILabel()
        signUp.text = "Login"
        signUp.textColor = .black
        signUp.font = .systemFont(ofSize: 60)
        return signUp
    }()
    
    private let background = {
        let background = UIView()
        background.backgroundColor = .white
        return background
    }()
    
    private let email = {
        let email = UILabel()
        email.text = "Email"
        email.font = .boldSystemFont(ofSize: 18)
        return email
    }()
    
    let emailTextField = {
        let email = UITextField()
        email.placeholder = "이메일을 입력해주세요"
        return email
    }()
    
    private let password = {
        let password = UILabel()
        password.text = "Password"
        password.font = .boldSystemFont(ofSize: 18)
        return password
    }()
    
    let passwordTextField = {
        let password = UITextField()
        password.placeholder = "비밀번호를 입력해주세요"
        return password
    }()
    
    let loginButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var rightBarButtonItem = {
        let right = UIBarButtonItem(title: "Sign up",
                                    style: .plain,
                                    target: self,
                                    action: #selector(self.rightBarButtonItemTapped))
        return right
    }()
    
    @objc func rightBarButtonItemTapped() { }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        rightBarButtonItem.tintColor = .black
    }
    
    override func configureHierarchy() {
        [login, background, loginButton].forEach {
            addSubview($0)
        }
        
        [email, emailTextField, password, passwordTextField].forEach {
            background.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        login.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalToSuperview().offset(40)
            $0.width.equalTo(200)
        }
        
        background.snp.makeConstraints {
            $0.top.equalTo(login.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(260)
        }
        
        email.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(email.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        password.snp.makeConstraints {
            $0.leading.equalTo(email)
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(password.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(background.snp.bottom).offset(-30)
            $0.horizontalEdges.equalTo(background).inset(10)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
