//
//  MyPostView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import BetterSegmentedControl
import SnapKit

final class MyPostView: BaseView {
    
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
        nickname.text = "test"
        return nickname
    }()
    
    let editProfileButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    private let segment = {
        let segment = BetterSegmentedControl(frame: .zero)
        segment.segments = LabelSegment.segments(withTitles: ["나의 메아리", "답장"])
        return segment
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(MyPostTableViewCell.self,
                    forCellReuseIdentifier: MyPostTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        return tableView
    }()
    
    override func configureHierarchy() {
        [profileImage, nickname, editProfileButton, segment, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalTo(self)
            $0.size.equalTo(70)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(5)
            $0.centerX.equalTo(self)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(nickname.snp.bottom).offset(5)
            $0.centerX.equalTo(self)
        }
        
        segment.snp.makeConstraints {
            $0.top.equalTo(editProfileButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
