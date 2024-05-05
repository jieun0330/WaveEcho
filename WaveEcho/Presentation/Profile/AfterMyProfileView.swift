//
//  AfterMyProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/2/24.
//

import UIKit
import SnapKit

final class AfterMyProfileView: BaseView {
    
    let profileImage = {
        let profile = UIImageView()
        profile.image = .profile
        profile.contentMode = .scaleAspectFill
        profile.layer.cornerRadius = 35
        profile.clipsToBounds = true
        return profile
    }()
    
    let nickname = {
        let nickname = UILabel()
        nickname.font = .boldSystemFont(ofSize: 20)
        return nickname
    }()
    
    let editNicknameButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    let withDrawButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        [profileImage, nickname, editNicknameButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().offset(40)
            $0.size.equalTo(70)
        }
        
        nickname.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        editNicknameButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.centerX.equalTo(profileImage)
        }
        
//        withDrawButton.snp.makeConstraints {
//            $0.leading.equalTo(editNicknameButton)
//            $0.top.equalTo(editNicknameButton.snp.bottom).offset(10)
//            $0.width.equalTo(100)
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
