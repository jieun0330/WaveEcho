//
//  PostsDetailView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import UIKit
import SnapKit

final class PostsDetailView: BaseView {
    
    private let letterView = {
        let letter = UIView()
        letter.backgroundColor = .orange
        return letter
    }()
    
    let nickname = {
        let nickname = UILabel()
        return nickname
    }()
    
    let contents = {
        let contents = UILabel()
        return contents
    }()
    
    let date = {
        let date = UILabel()
        date.text = "date test"
        return date
    }()
    
    private let comment = {
        let comment = UIButton()
        comment.setTitle("댓글", for: .normal)
        comment.backgroundColor = .systemGray
        return comment
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [letterView, comment].forEach {
            addSubview($0)
        }
        
        [nickname, contents, date].forEach {
            letterView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        letterView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        nickname.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        contents.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(nickname.snp.bottom).offset(10)
        }
        
        date.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(20)
        }
                
        comment.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
