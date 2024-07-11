//
//  ChatListTableViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 5/19/24.
//

import UIKit
import SnapKit

final class ChatListTableViewCell: BaseTableViewCell, ReusableProtocol {
    
    let profileImg = {
        let profile = UIImageView()
        return profile
    }()
    
    let userID = {
        let id = UILabel()
        id.font = .systemFont(ofSize: 12)
        return id
    }()
    
    let message = {
        let message = UILabel()
        return message
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .blue
    }
    
    override func configureHierarchy() {
        [profileImg, userID, message].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        profileImg.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(50)
        }
        
        userID.snp.makeConstraints {
            $0.top.equalTo(profileImg)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
        }
        
//        message.snp.makeConstraints {
//            $0.leading.equalTo(userID)
//            $0.top.equalTo(use)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
