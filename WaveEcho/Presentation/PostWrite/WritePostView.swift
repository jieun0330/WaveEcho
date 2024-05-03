//
//  ContentView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import SnapKit
import Lottie

class WritePostView: BaseView {
    
    lazy var seaBackgroundLottiView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "wavesAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: .max, height: .max)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 2
        animationView.play()
        return animationView
    }()
    
    lazy var contentTextView = {
        let content = UITextView()
        content.font = .systemFont(ofSize: 20)
        content.text = "파도 속으로 메아리를 던져볼까요?"
        content.textColor = .lightGray
        content.backgroundColor = .none
        content.delegate = self
        return content
    }()
    
    let letterView = {
        let view = UIView()
        view.backgroundColor = .systemCyan.withAlphaComponent(0.3)
        return view
    }()
    
    let presentPhotoView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.layer.borderWidth = 1
        photo.layer.borderColor = UIColor.orange.cgColor
        return photo
    }()
    
    let uploadPhotoButton = {
        let button = UIButton()
        button.setTitle("사진", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let sendButton = {
        let button = UIButton()
        button.setTitle("던지기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        return button
    }()
    
//    lazy var rightBarButtonItem = {
//        let item = UIBarButtonItem()
//        item.title = "완료"
//        return item
//    }()
//    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
        
    override func configureHierarchy() {
        [seaBackgroundLottiView, letterView, contentTextView, presentPhotoView, uploadPhotoButton, sendButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        contentTextView.snp.makeConstraints {
            $0.centerX.equalTo(letterView)
            $0.top.equalTo(letterView.snp.top).offset(20)
            $0.horizontalEdges.equalTo(letterView).inset(20)
            $0.height.equalTo(100)
        }
        
        seaBackgroundLottiView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        
        letterView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        presentPhotoView.snp.makeConstraints {
            $0.centerX.equalTo(letterView)
            $0.bottom.equalTo(uploadPhotoButton.snp.top).offset(-20)
            $0.size.equalTo(250)
        }
        
        uploadPhotoButton.snp.makeConstraints {
            $0.leading.equalTo(letterView.snp.leading).offset(20)
            $0.bottom.equalTo(letterView.snp.bottom).offset(-20)
            $0.centerY.equalTo(sendButton)
            $0.width.equalTo(100)
        }
        
        sendButton.snp.makeConstraints {
            $0.bottom.equalTo(uploadPhotoButton)
            $0.trailing.equalTo(letterView).inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WritePostView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = .black
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "파도 속으로 메아리를 던져볼까요?"
            textView.textColor = .lightGray
        }
    }
}
