//
//  ReplyView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import SnapKit

final class ReplyView: BaseView {
    
    let toPerson = {
        let person = UILabel()
        person.font = .boldSystemFont(ofSize: 15)
        person.sizeToFit()
        person.numberOfLines = 0
        return person
    }()

    let replyTo = {
        let reply = UILabel()
        reply.text = "에게 답장하기"
        reply.font = .systemFont(ofSize: 15)
        return reply
    }()
    
    lazy var replyTextView = {
        let reply = UITextView()
        reply.text = "답장을 보내볼까요?"
        reply.textColor = .lightGray
        reply.delegate = self
        reply.isScrollEnabled = false
        return reply
    }()
    
    let sendButton = {
        let button = UIButton()
        button.setTitle("던지기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        [toPerson, replyTo, replyTextView, sendButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        toPerson.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(40)
        }
        
        replyTo.snp.makeConstraints {
            $0.leading.equalTo(toPerson.snp.trailing).offset(5)
            $0.top.equalTo(toPerson)
        }
        
        replyTextView.snp.makeConstraints {
            $0.top.equalTo(toPerson.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.greaterThanOrEqualTo(40)
        }

        sendButton.snp.makeConstraints {
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-10)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReplyView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = .black
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "답장을 보내볼까요?"
            textView.textColor = .lightGray
        }
    }
}
