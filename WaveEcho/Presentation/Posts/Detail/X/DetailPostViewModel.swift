//
//  DetailPostViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailPostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var postID: String!
    
    struct Input {
        let sendButtonTapped: ControlEvent<Void>
        let commentContent: ControlProperty<String>
        let viewWillAppearTrigger: Observable<Bool>
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
//        let testObservable = PublishRelay<[CommentData]>()

        // 댓글 달면
        input.sendButtonTapped
            .withLatestFrom(input.commentContent)
            .map { content in
                WriteCommentRequestBody(content: content)
            }
            .flatMap { writeCommentRequest in
                APIManager.shared.create(type: WriteCommentResponse.self,
                                         router: CommentRouter.writeComment(query: writeCommentRequest,
                                                                            id: input.postID))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    commentSuccess.accept(success)
                    commentTrigger.accept(())
                case .failure(let error):
                    commentError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
//        Observable.combineLatest(input.commentID, input.commentContent)
//            .flatMap { id, content in
//                return APIManager.shared.create(type: WriteCommentResponse.self,
//                                                router: CommentRouter.writeComment(query: WriteCommentRequestBody(content: content), id: id))
//            }
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let success):
//                    print("success 🧎🏻‍♀️", success)
//                    commentSuccess.accept(success)
//                    commentTrigger.accept(())
//                case .failure(let error):
//                    print("error 🧍🏻‍♂️", error)
//                    commentError.accept(error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(commentSuccess: commentSuccess.asDriver(onErrorJustReturn: WriteCommentResponse(comment_id: input.postID,
                                                                                                      content: "",
                                                                                                      createdAt: "",
                                                                                                      creator: Creator(user_id: "",
                                                                                                                       nick: "",
                                                                                                                       profileImage: ""))),
                      commentError: commentError.asDriver(onErrorJustReturn: .code500),
                      commentTrigger: commentTrigger.asDriver(onErrorJustReturn: ()))
    }
}
