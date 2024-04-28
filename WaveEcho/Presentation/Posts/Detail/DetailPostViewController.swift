//
//  PostsDetailViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailPostViewController: BaseViewController {
    
    let mainView = DetailPostView()

    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.replyTextView.isHidden = true
        mainView.sendButton.isHidden = true
    }
    
    override func configureView() {
        mainView.comment.rx.tap
            .bind(with: self) { owner, _ in
                owner.mainView.replyTextView.isHidden = false
                owner.mainView.sendButton.isHidden = false
            }
            .disposed(by: disposeBag)
        
        // 여기 아님
//        navigationController?.navigationItem.backButtonTitle = ""
    }
}
