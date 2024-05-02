//
//  ProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit
import SnapKit
import Lottie

final class MyProfileView: BaseView {
    
//    lazy var profileLottiView : LottieAnimationView = {
//        let animationView = LottieAnimationView(name: "profileAnimation")
//        animationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
////        animationView.center = center
//        animationView.contentMode = .scaleAspectFill
//        animationView.loopMode = .autoReverse
//        animationView.animationSpeed = 2
//        return animationView
//    }()
//    
    let profileImage = {
        let profile = UIImageView()
        profile.image = UIImage(systemName: "square.text.square")
        profile.layer.borderColor = UIColor.red.cgColor
        profile.layer.borderWidth = 1
        return profile
    }()
    
    let nickname = {
        let nickname = UILabel()
        nickname.font = .boldSystemFont(ofSize: 15)
        return nickname
    }()
    
    let editNicknameButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .brown
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
            $0.top.equalTo(profileImage).offset(5)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
