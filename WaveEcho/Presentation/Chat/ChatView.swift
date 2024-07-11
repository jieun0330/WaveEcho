//
//  ChatView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import UIKit
import SnapKit

final class ChatView: BaseView {
    
    let textFieldBackView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let chatTextField = {
        let chat = UITextField()
        chat.placeholder = "메세지를 입력하세요"
        chat.backgroundColor = .systemGray6
        return chat
    }()
    
    private let sendButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        return button
    }()
    
    private let myChat = {
        let chat = UILabel()
        return chat
    }()
    
    override func configureHierarchy() {
        [textFieldBackView, chatTextField, myChat].forEach {
            addSubview($0)
        }
        
//        [chatTextField, sendButton].forEach {
//            textFieldBackView.addSubview($0)
//        }
    }
    
    override func configureConstraints() {
        
//        textFieldBackView.snp.makeConstraints {
//            $0.bottom.horizontalEdges.equalToSuperview()
//            $0.height.equalTo(80)
//        }
        
        chatTextField.snp.makeConstraints {
            $0.left.right.bottom.equalTo(safeAreaLayoutGuide)
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().inset(30)
//            $0.bottom.leading.equalToSuperview()
//            $0.height.equalTo(50)
        }
        
//        sendButton.snp.makeConstraints {
//            $0.bottom.equalTo(chatTextField)
//            $0.leading.equalTo(chatTextField.snp.trailing)
//            $0.trailing.equalToSuperview().inset(30)
//            $0.width.equalTo(50)
//        }
//        
//        myChat.snp.makeConstraints {
//            $0.
//        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
