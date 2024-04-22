//
//  PostsCollectionViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

import UIKit
import SnapKit

class PostsCollectionViewCell: BaseCollectionViewCell {
    
    static var identifer = "identifier"
    
    let contents = {
        let contents = UILabel()
        contents.text = "contents"
        return contents
    }()
    
    let date = {
        let date = UILabel()
        date.text = "date"
        return date
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [contents, date].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        contents.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(10)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
//    override func configureView() {
//        <#code#>
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
