//
//  MyPostTableViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MyPostTableViewCell: BaseTableViewCell, ReusableProtocol {
    
    private let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let contentImage = {
        let image = UIImageView()
        image.backgroundColor = .brown
        return image
    }()
    
    private let contents = {
        let contents = UILabel()
        contents.numberOfLines = 0
        contents.sizeToFit()
        return contents
    }()
    
    private let date = {
        let date = UILabel()
        date.font = .systemFont(ofSize: 13)
        date.textColor = .systemGray
        return date
    }()
    
    private let editButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        [backView, editButton, deleteButton].forEach {
            contentView.addSubview($0)
        }
        
        [contentImage, contents, date].forEach {
            backView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.size.equalTo(80)
        }
        
        contents.snp.makeConstraints {
            $0.leading.equalTo(contentImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.top.equalTo(contentImage)
        }
        
        date.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setData(_ data: PostData) {
        contents.text = data.content
        let stringDate = DateFormatManager.shared.stringToDate(date: data.createdAt)
        let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
        date.text = relativeDate
        contentImage.kf.setImage(with: URL(string: data.files?.first ?? ""))
        
        if let contentImageUrl = URL(string: data.files?.first ?? "") {
            contentImage.kf.setImage(with: contentImageUrl, options: [.requestModifier(KingFisherNet())])
        } else {
            contentImage.image = .whitePaper
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
