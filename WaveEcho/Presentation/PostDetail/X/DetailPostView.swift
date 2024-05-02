////
////  PostsDetailView.swift
////  WaveEcho
////
////  Created by 박지은 on 4/28/24.
////
//
//import UIKit
//import SnapKit
//
//final class DetailPostView: BaseView {
//    
//    //    private let scrollView = {
//    //        let scrollView = UIScrollView()
//    //        scrollView.backgroundColor = .red
//    //        return scrollView
//    //    }()
//    //    
//    //    private let contentView = {
//    //        let contentView = UIView()
//    //        contentView.backgroundColor = .yellow
//    //        return contentView
//    //    }()
//    
//    private let letterView = {
//        let letter = UIView()
//        letter.backgroundColor = .orange
//        return letter
//    }()
//    
//    let nickname = {
//        let nickname = UILabel()
//        return nickname
//    }()
//    
//    let contents = {
//        let contents = UILabel()
//        contents.numberOfLines = 0
//        return contents
//    }()
//    
//    let image = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//        return image
//    }()
//    
//    let date = {
//        let date = UILabel()
//        return date
//    }()
//    
//    let successCommentTest = {
//        let successTest = UILabel()
//        successTest.backgroundColor = .brown
//        return successTest
//    }()
//    
//    let replyTextView = {
//        let reply = UITextView()
//        reply.backgroundColor = .blue
//        return reply
//    }()
//    
//    let sendButton = {
//        let send = UIButton()
//        send.setTitle("전송", for: .normal)
//        send.setTitleColor(.black, for: .normal)
//        send.backgroundColor = .brown
//        return send
//    }()
//    
//    override init(frame: CGRect) {
//        super .init(frame: frame)
//    }
//    
//    override func configureHierarchy() {
//        //        [scrollView].forEach {
//        //            addSubview($0)
//        //        }
//        //        
//        //        [contentView].forEach {
//        //            scrollView.addSubview($0)
//        //        }
//        
//        [nickname, contents, image, date].forEach {
//            letterView.addSubview($0)
//        }
//        
//        [letterView, successCommentTest, replyTextView, sendButton].forEach {
//            addSubview($0)
//        }
//    }
//    
//    override func configureConstraints() {
//        
//        //        scrollView.snp.makeConstraints {
//        //            $0.edges.equalToSuperview()
//        //        }
//        //        
//        //        contentView.snp.makeConstraints {
//        //            $0.edges.equalTo(scrollView)
//        //            $0.width.equalTo(scrollView.frameLayoutGuide)
//        //        }
//        //        
//        letterView.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.bottom.equalTo(date).offset(20)
//        }
//        
//        nickname.snp.makeConstraints {
//            $0.top.leading.equalToSuperview().inset(20)
//        }
//        
//        contents.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.top.equalTo(nickname.snp.bottom).offset(20)
//        }
//        
//        image.snp.makeConstraints {
//            $0.top.equalTo(contents.snp.bottom).offset(20)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.height.equalTo(300)
//        }
//        
//        date.snp.makeConstraints {
//            $0.top.equalTo(image.snp.bottom).offset(20)
//            $0.trailing.equalToSuperview().inset(20)
//        }
//        
//        successCommentTest.snp.makeConstraints {
//            $0.top.equalTo(letterView.snp.bottom).offset(20)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.height.equalTo(50)
//        }
//        
//        replyTextView.snp.makeConstraints {
//            $0.top.equalTo(successCommentTest.snp.bottom).offset(20)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.height.equalTo(50)
//        }
//        
//        sendButton.snp.makeConstraints {
//            $0.top.equalTo(replyTextView.snp.bottom).offset(5)
//            $0.trailing.equalTo(replyTextView)
//            $0.width.equalTo(100)
//        }                
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
