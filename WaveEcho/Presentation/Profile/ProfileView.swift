//
//  ProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    private let profileImage = {
        let profile = UIImageView()
        profile.image = UIImage(systemName: "square.text.square")
        return profile
    }()
    
    private let nickname = {
        let nickname = UILabel()
        nickname.text = "cyndi"
        return nickname
    }()
    
    private let editNicknameButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        return button
    }()
    
    private let withDrawButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [profileImage, nickname, editNicknameButton, withDrawButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(100)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        editNicknameButton.snp.makeConstraints {
            $0.leading.equalTo(profileImage)
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.width.equalTo(100)
        }
        
        withDrawButton.snp.makeConstraints {
            $0.leading.equalTo(editNicknameButton)
            $0.top.equalTo(editNicknameButton.snp.bottom).offset(10)
            $0.width.equalTo(100)
        }
    }
    
//    override func configureView() {
//        <#code#>
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
