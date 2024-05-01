//
//  MyPostTableViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import SnapKit

final class MyPostTableViewCell: BaseTableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let contents = {
        let contents = UILabel()
        return contents
    }()
    
    let date = {
        let date = UILabel()
        date.font = .systemFont(ofSize: 13)
        date.textColor = .systemGray
        return date
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        [backView].forEach {
            contentView.addSubview($0)
        }
        
        [contents, date].forEach {
            backView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contents.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(5)
        }
        
        date.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
