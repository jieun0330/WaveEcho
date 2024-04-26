//
//  ContentView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import SnapKit

class ContentView: BaseView {
    
    let contentTextView = {
        let content = UnderlineTextView()
//        content.backgroundColor = .orange
        return content
    }()
    
    let presentPhotoView = {
        let photo = UIImageView()
        return photo
    }()
    
    let uploadPhotoButton = {
        let button = UIButton()
        button.setTitle("사진", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let completeButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var rightBarButtonItem = {
        let right = UIBarButtonItem(title: "완료",
                                    style: .plain,
                                    target: self,
                                    action: #selector(self.rightBarButtonItemTapped))
        return right
    }()
    
    @objc private func rightBarButtonItemTapped() {
        endEditing(true)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
        
    override func configureHierarchy() {
        [contentTextView, presentPhotoView, uploadPhotoButton, completeButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(100)
        }
        
        presentPhotoView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(contentTextView)
            $0.height.equalTo(300)
        }
        
        uploadPhotoButton.snp.makeConstraints {
//            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerY.equalTo(completeButton)
            $0.width.equalTo(100)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
//            $0.bottom.equalTo(uploadPhotoButton)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
