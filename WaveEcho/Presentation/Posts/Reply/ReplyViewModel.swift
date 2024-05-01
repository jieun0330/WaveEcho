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

    struct Input {
        let sendButtonTapped: ControlEvent<Void>
        let commentContent: ControlProperty<String>
        let postID: String
    }

    struct Output {
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
                print("🐥",writeCommentRequest, "id: \(input.postID)")
                return APIManager.shared.create(type: WriteCommentResponse.self,
                                         router: CommentRouter.writeComment(query: writeCommentRequest,
                                                                            id: "6631c59cea1f6976de7ccd86"))
            }
            .bind(with: self) { owner, result in
                dump(result)
                print("🐭🐭", result)
                switch result {
                case .success(let success):
                    print("아 제발",success)
                    commentSuccess.accept(success)
                    commentTrigger.accept(())
                case .failure(let error):
                    print("🦊여우가 범의 허리를 끊었다", error)
                    dump(error)
                    commentError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(commentSuccess: commentSuccess.asDriver(onErrorJustReturn: WriteCommentResponse(comment_id: "",
                                                                                                      content: "",
                                                                                                      createdAt: "",
                                                                                                      creator: Creator(user_id: "",
                                                                                                                       nick: "",
                                                                                                                       profileImage: ""))),
                      commentError: commentError.asDriver(onErrorJustReturn: .code500),
                      commentTrigger: commentTrigger.asDriver(onErrorJustReturn: ()))
    }
}

