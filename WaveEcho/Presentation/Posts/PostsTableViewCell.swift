//
//  PostsTableViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

import UIKit
import SnapKit

class PostsTableViewCell: BaseTableViewCell {
    
    let contents = {
        let contents = UILabel()
        contents.text = "contents"
        contents.numberOfLines = 0
        return contents
    }()
    
    let date = {
        let date = UILabel()
        date.text = "date"
        date.textColor = .lightGray
        date.font = .systemFont(ofSize: 10)
        return date
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 30, right: 6))
    }
    
    override func configureHierarchy() {
        [contents, date].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {

        contents.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalTo(date.snp.leading).offset(10)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func configureView() {

        contentView.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
