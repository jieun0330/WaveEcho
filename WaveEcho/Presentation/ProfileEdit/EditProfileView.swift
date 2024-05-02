//
//  EditProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    
    let nicknameLabel = {
        let nickname = UILabel()
        nickname.text = "닉네임"
        return nickname
    }()
    
    let nicknameTextField = {
        let nickname = UITextField()
        nickname.backgroundColor = .systemGray6
        return nickname
    }()
    
    lazy var editButton = {
        let item = UIBarButtonItem()
        item.title = "수정"
        return item
    }()
    
    let withDrawButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.systemGray5, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [nicknameLabel, nicknameTextField, withDrawButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        withDrawButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
