//
//  ReplyViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ReplyViewController: BaseViewController {
    
    private let imageData = PublishRelay<Data>()
    let mainView = ReplyView()
    private let viewModel = ReplyViewModel()
    var postID: String!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        guard let postID else { return }
        
        let input = ReplyViewModel.Input(sendButtonTapped: mainView.sendButton.rx.tap,
                                         commentContent: mainView.replyTextView.rx.text.orEmpty,
                                         postID: postID)
        
        let output = viewModel.transform(input: input)
        
        output.commentSuccess
            .drive(with: self) { owner, writeCommentResponse in
                
//                owner.mainView.successCommentTest.text = writeCommentResponse.content
            }
            .disposed(by: disposeBag)

        output.commentError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .writeComment)
            }
            .disposed(by: disposeBag)
            }
}
