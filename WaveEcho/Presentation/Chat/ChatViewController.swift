//
//  ChatViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import UIKit
import RxKeyboard
import SnapKit

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyboardVisibleHeight in
                print(keyboardVisibleHeight) // 291
                owner.mainView.chatTextField.snp.updateConstraints {
                    $0.bottom.equalTo(owner.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight)
                }
            }
            .disposed(by: disposeBag)
    }
}
