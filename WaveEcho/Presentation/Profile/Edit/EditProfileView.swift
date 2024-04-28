//
//  EditProfileView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    
    let nicknameTextField = {
        let nickname = UITextField()
        return nickname
    }()
    
    lazy var rightBarButtonItem = {
        let right = UIBarButtonItem(title: "완료",
                                    style: .plain,
                                    target: self,
                                    action: #selector(self.rightBarButtonItemTapped))
        return right
    }()
    
    @objc private func rightBarButtonItemTapped() { }

    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [nicknameTextField].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
