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
    var writeCommentResponse: WriteCommentResponse!
    private let viewModel = DetailPostViewModel()

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
    
    override func bind() {
        print("test 🫀", writeCommentResponse)
        
//        let input = DetailPostViewModel.Input(sendButtonTapped: mainView.sendButton.rx.tap,
//                                              commentID: Observable.just(writeCommentResponse.comment_id),
//                                              commentContent: mainView.replyTextView.rx.text.orEmpty)
//        
//        let output = viewModel.transform(input: input)
//        
//        output.commentSuccess.asObservable()
//            .bind(with: self) { owner, writeCommentResponse in
//                print("test 💄", writeCommentResponse)
//            }
//            .disposed(by: disposeBag)
    }
}
