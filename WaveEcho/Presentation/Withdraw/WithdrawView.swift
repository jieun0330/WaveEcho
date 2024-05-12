//
//  WithdrawView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/12/24.
//

import UIKit
import SnapKit

final class WithdrawView: BaseView {
    
    private let password = {
        let password = UILabel()
        password.text = "비밀번호"
        return password
    }()
    
    let passwordTextField = {
        let password = UITextField()
        password.layer.borderColor = UIColor.systemGray6.cgColor
        password.layer.borderWidth = 1
        password.isSecureTextEntry = true
        return password
    }()
    
    private let passwordCheck = {
        let password = UILabel()
        password.text = "비밀번호 확인"
        return password
    }()
    
    let passwordCheckTextField = {
        let password = UITextField()
        password.layer.borderColor = UIColor.systemGray6.cgColor
        password.layer.borderWidth = 1
        password.isSecureTextEntry = true
        return password
    }()
    
    let withdrawButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.backgroundColor = .systemGray6
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        
        [password, passwordTextField, passwordCheck, passwordCheckTextField, withdrawButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        password.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(password.snp.bottom).offset(5)
            $0.leading.equalTo(password)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        
        passwordCheck.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalTo(passwordTextField)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheck.snp.bottom).offset(5)
            $0.leading.equalTo(passwordCheck)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
