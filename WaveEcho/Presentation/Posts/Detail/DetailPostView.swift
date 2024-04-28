//
//  PostsDetailView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import UIKit
import SnapKit

final class DetailPostView: BaseView {
    
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
    
    let comment = {
        let comment = UIButton()
        comment.setTitle("댓글", for: .normal)
        comment.backgroundColor = .systemGray
        return comment
    }()
    
    let replyTextView = {
        let reply = UITextView()
        reply.backgroundColor = .blue
        return reply
    }()
    
    let sendButton = {
        let send = UIButton()
        send.setTitle("전송", for: .normal)
        send.setTitleColor(.black, for: .normal)
        send.backgroundColor = .brown
        return send
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [letterView, replyTextView, sendButton, comment].forEach {
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
        
        replyTextView.snp.makeConstraints {
            $0.top.equalTo(letterView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.equalTo(replyTextView.snp.bottom).offset(5)
            $0.trailing.equalTo(replyTextView)
            $0.width.equalTo(100)
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
