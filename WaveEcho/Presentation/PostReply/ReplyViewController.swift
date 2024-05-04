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
import Toast

protocol fetchComment: AnyObject {
    func fetchDone(data: CommentData)
}

final class ReplyViewController: BaseViewController {
    
    let mainView = ReplyView()
    private let viewModel = ReplyViewModel()
    var postID = BehaviorRelay<String>(value: "")
    weak var delegate: fetchComment?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = ReplyViewModel.Input(sendButtonTapped: mainView.sendButton.rx.tap,
                                         commentContent: mainView.replyTextView.rx.text.orEmpty,
                                         postID: postID)
        
        let output = viewModel.transform(input: input)
        
        output.commentTrigger
            .drive(with: self) { owner, _ in
                owner.view.endEditing(true)
                owner.view.makeToast("답장을 보냈습니다")
            }
            .disposed(by: disposeBag)
        
        // 1초 후 화면 전환
        output.commentTrigger
            .debounce(.seconds(1))
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
                owner.mainView.replyTextView.text = nil
            }
            .disposed(by: disposeBag)
        
        output.commentError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .writeComment)
            }
            .disposed(by: disposeBag)
        
        output.updateCommentData
            .drive(with: self) { owner, commentModel in
                guard let comment = commentModel.first else { return }
                let creator = comment.creator
                let creatorInfo = CreatorInfo(user_id: creator.user_id,
                            nick: creator.nick,
                            profileImage: creator.profileImage)
                owner.delegate?.fetchDone(data: CommentData(comment_id: comment.comment_id,
                                                            content: comment.content,
                                                            createdAt: comment.createdAt,
                                                            creator: creatorInfo))
            }
            .disposed(by: disposeBag)
    }
}
