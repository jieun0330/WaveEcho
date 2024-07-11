//
//  CommentCollectionViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 4/30/24.
//

import UIKit
import SnapKit

final class CommentCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let commentUserProfileImage = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let commentUserNickname = {
        let nickname = UILabel()
        nickname.textColor = .black
        nickname.font = .systemFont(ofSize: 10)
        return nickname
    }()
    
    let commentLabel = {
        let comment = UILabel()
        comment.sizeToFit()
        comment.numberOfLines = 0
        
        return comment
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [commentUserProfileImage, commentUserNickname, commentLabel].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        commentUserProfileImage.snp.makeConstraints {
            $0.leading.top.equalTo(contentView)
            $0.size.equalTo(20)
        }
        
        commentUserNickname.snp.makeConstraints {
            $0.leading.equalTo(commentUserProfileImage)
            $0.top.equalTo(commentUserProfileImage.snp.bottom).offset(5)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(commentUserProfileImage)
            $0.leading.equalTo(commentUserProfileImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(self)
    }
}
