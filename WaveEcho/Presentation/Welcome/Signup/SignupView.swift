//
//  SignupView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import SnapKit
import Lottie

class SignupView: BaseView {
    
    lazy var seaBackgroundLottiView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "wavesAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: .max, height: .max)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 2
        animationView.play()
        return animationView
    }()
    
    private let signUp = {
        let signUp = UILabel()
        signUp.text = "Sign up"
        signUp.textColor = .black
        signUp.font = .systemFont(ofSize: 60)
        return signUp
    }()
    
    private let background = {
        let background = UIView()
        background.backgroundColor = .systemCyan.withAlphaComponent(0.1)
        return background
    }()
    
    private let nickname = {
        let nickname = UILabel()
        nickname.text = "Nickname"
        nickname.font = .boldSystemFont(ofSize: 18)
        return nickname
    }()
    
    let nicknameTextField = {
        let nickname = UITextField()
        nickname.placeholder = "닉네임을 2자 이상 입력해주세요"
        return nickname
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
        email.keyboardType = .emailAddress
        // 수정 제안 비활성화
        email.autocapitalizationType = .none
        email.autocorrectionType = .no
        email.spellCheckingType = .no
        return email
    }()
    
    let validEmail = {
        let email = UILabel()
        email.font = .systemFont(ofSize: 14)
        email.textColor = .red
        return email
    }()
    
    let validEmailButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.backgroundColor = .systemCyan
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let password = {
        let password = UILabel()
        password.text = "Password"
        password.font = .boldSystemFont(ofSize: 18)
        return password
    }()
    
    let passwordTextField = {
        let password = UITextField()
        password.placeholder = "비밀번호를 4자 이상 입력해주세요"
        password.isSecureTextEntry = true
        return password
    }()
    
    let signupButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var rightBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "Login"
        return item
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        rightBarButtonItem.tintColor = .black
        validEmail.isHidden = true
    }
    
    override func configureHierarchy() {
        [seaBackgroundLottiView, signUp, background, signupButton].forEach {
            addSubview($0)
        }
        
        [nickname, nicknameTextField, email, emailTextField, validEmailButton, validEmail,
         password, passwordTextField].forEach {
            background.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        seaBackgroundLottiView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        signUp.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalToSuperview().offset(40)
            $0.width.equalTo(200)
        }
        
        background.snp.makeConstraints {
            $0.top.equalTo(signUp.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(340)
        }
        
        nickname.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nickname.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        email.snp.makeConstraints {
            $0.leading.equalTo(nickname)
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(35)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(email.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        validEmailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalTo(emailTextField)
            $0.width.equalTo(80)
        }

        validEmail.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(5)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(validEmailButton)
            $0.height.equalTo(20)
        }
        
        password.snp.makeConstraints {
            $0.leading.equalTo(email)
            $0.top.equalTo(emailTextField.snp.bottom).offset(35)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(password.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(background.snp.bottom).offset(-30)
            $0.horizontalEdges.equalTo(background).inset(10)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
