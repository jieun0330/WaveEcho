//
//  MyPopupView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/30/24.
//

import UIKit
import SnapKit

final class PopupView: BaseView {
    
    private let popupView =  {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let profileImage = {
        let profile = UIImageView()
        profile.image = UIImage(systemName: "circle.fill")
        return profile
    }()
    
    var nicknameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let contentImage = {
        let contentImage = UIImageView()
        return contentImage
    }()
    
    let date = {
        let date = UILabel()
        date.font = .systemFont(ofSize: 12)
        date.textColor = .systemGray
        return date
    }()
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        collectionView.register(CommentCollectionViewCell.self,
                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let throwButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("던지기", for: .normal)
        button.setBackgroundImage(UIColor.systemBlue.withAlphaComponent(0.5).asImage(), for: .normal)
        button.setBackgroundImage(UIColor.systemBlue.asImage(), for: .highlighted)
        return button
    }()
    
    let replyButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("답장", for: .normal)
        button.setBackgroundImage(UIColor.systemBlue.asImage(), for: .normal)
        button.setBackgroundImage(UIColor.blue.asImage(), for: .highlighted)
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        
        [popupView].forEach {
            addSubview($0)
        }
        
        [contentView, date, collectionView, throwButton, replyButton].forEach {
            popupView.addSubview($0)
        }
        
        [profileImage, nicknameLabel, contentLabel, contentImage].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.verticalEdges.equalTo(safeAreaLayoutGuide).inset(32)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        profileImage.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
            $0.centerY.equalTo(profileImage)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentImage.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentImage.snp.width)
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(contentImage.snp.bottom).offset(5)
            $0.trailing.equalTo(contentLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(date.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(throwButton.snp.top)
        }
        
        throwButton.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(56)
        }
        
        replyButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    func asImage(_ width: CGFloat = UIScreen.main.bounds.width, _ height: CGFloat = 1.0) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
            setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
