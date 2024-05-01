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

final class ReplyViewController: BaseViewController {
    
    let mainView = ReplyView()
    private let imageData = PublishRelay<Data>()
    private let viewModel = ReplyViewModel()
    var postID: String!
    //    let popupVC = PopupViewController() // 콜수 가 미친듯이 올라감
    //    var getCommentUser: getCommentUser?
    
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
        
        //        output.commentSuccess
        //            .drive(with: self) { owner, model in
        //                owner.getCommentUser?.getCommentUser(writeCommentResponse: model)
        //            }
        //            .disposed(by: disposeBag)
        
        output.commentError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .writeComment)
            }
            .disposed(by: disposeBag)
        
        output.updateCommentData
            .drive(with: self) { owner, commentModel in
                //                owner.popupVC.test.accept(commentModel.first!)
                print("🐷🐷🐷🐷🐷", commentModel.first?.content ?? "코멘트 없음")
            }
            .disposed(by: disposeBag)
    }
}
