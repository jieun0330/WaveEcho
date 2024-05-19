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
        profile.image = UIImage(systemName: "star")
        return profile
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .blue
    }
    
    override func configureHierarchy() {
        [profileImg].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        profileImg.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
