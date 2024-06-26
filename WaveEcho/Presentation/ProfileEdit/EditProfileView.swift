//
//  EditProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    
    let profileImg = {
        let image = UIImageView()
        image.image = .profile
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        return image
    }()

    let nicknameLabel = {
        let nickname = UILabel()
        nickname.text = "닉네임"
        return nickname
    }()
    
    let nicknameTextField = {
        let nickname = UITextField()
        nickname.layer.borderColor = UIColor.systemGray6.cgColor
        nickname.layer.borderWidth = 1
        nickname.layer.cornerRadius = 10
        return nickname
    }()
    
    let withDrawButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.systemGray5, for: .normal)
        return button
    }()
    
    private let doneButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.backgroundColor = UIColor(hexCode: "1A79E9", alpha: 0.6)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [profileImg, nicknameLabel, nicknameTextField, withDrawButton, doneButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        profileImg.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(40)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(20)
            $0.width.equalTo(240)
            $0.height.equalTo(50)
        }
        
        withDrawButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(-10)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
