//
//  WelcomeView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit
import SnapKit
import Lottie

final class WelcomeView: BaseView {
    
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
    
    private let hello = {
        let hello = UILabel()
        hello.text = "Hello"
        hello.textColor = .black
        hello.font = .systemFont(ofSize: 60)
        return hello
    }()
    
    let loginButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 20
        return button
    }()
    
    let signUpButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        [seaBackgroundLottiView, hello, loginButton, signUpButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        seaBackgroundLottiView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        hello.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.leading.equalToSuperview().offset(40)
            $0.width.equalTo(200)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(hello.snp.bottom).offset(100)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
