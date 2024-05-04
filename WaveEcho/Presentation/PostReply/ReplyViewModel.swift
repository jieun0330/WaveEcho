//
//  ReplyViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReplyViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var updateCommentData = BehaviorRelay<[WriteCommentResponse]>(value: [])
    
    struct Input {
        let sendButtonTapped: ControlEvent<Void>
        let commentContent: ControlProperty<String>
        let postID: BehaviorRelay<String>
    }
    
    struct Output {
        let updateCommentData: Driver<[WriteCommentResponse]>
        let commentSuccess: Driver<WriteCommentResponse>
        let commentError: Driver<APIError>
        let commentTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let commentSuccess = PublishRelay<WriteCommentResponse>()
        let commentError = PublishRelay<APIError>()
        let commentTrigger = PublishRelay<Void>()
        
        // 댓글 달면
        input.sendButtonTapped
            .withLatestFrom(input.commentContent)
            .map { content in
                WriteCommentRequestBody(content: content)
            }
            .flatMapLatest { writeCommentRequest in
                return APIManager.shared.create(type: WriteCommentResponse.self,
                                                router: CommentRouter.writeComment(query: writeCommentRequest,
                                                                                   id: input.postID.value))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    
                    commentSuccess.accept(success)
                    commentTrigger.accept(())
                    
                    var updateComment = owner.updateCommentData.value
                    updateComment.insert(success, at: 0)
                    owner.updateCommentData.accept(updateComment)
                case .failure(let error):
                    commentError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(updateCommentData: updateCommentData.asDriver(),
                      commentSuccess: commentSuccess.asDriver(onErrorJustReturn: WriteCommentResponse(comment_id: "",
                                                                                                      content: "",
                                                                                                      createdAt: "",
                                                                                                      creator: Creator(user_id: "",
                                                                                                                       nick: "",
                                                                                                                       profileImage: ""))),
                      commentError: commentError.asDriver(onErrorJustReturn: .code500),
                      commentTrigger: commentTrigger.asDriver(onErrorJustReturn: ()))
    }
}

