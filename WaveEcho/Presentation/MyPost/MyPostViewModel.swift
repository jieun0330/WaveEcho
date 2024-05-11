//
//  MyPostViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let deletePostID: BehaviorRelay<String>
        // 포스트 삭제
        let tableViewModelData: ControlEvent<PostData>
    }
    
    struct Output {
        let postDataSuccess: Driver<[PostData]>
        let postDataError: Driver<APIError>
        let deletePostID: Driver<String>
        let viewWillAppearTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let postDataSuccess = PublishRelay<[PostData]>()
        let postDataError = PublishRelay<APIError>()
        // 포스트 삭제
        let deletePostSuccess = PublishRelay<Void>()
        let deletePostError = PublishRelay<APIError>()
        
        input.viewDidLoad
            .flatMap { _ in
                return APIManager.shared.create(type: PostResponse.self,
                                                router: PostsRouter.userPost(id: UserDefaults.standard.string(forKey: "userID") ?? ""))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postDataSuccess.accept(success.data)
                case .failure(let error):
                    postDataError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 포스트 삭제
        input.tableViewModelData
            .flatMap { postData in
                APIManager.shared.create(type: PostResponse.self, router: PostsRouter.delePost(id: postData.post_id))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    deletePostSuccess.accept(())
                    postDataSuccess.accept(success.data)
                case .failure(let error):
                    deletePostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postDataSuccess: postDataSuccess.asDriver(onErrorJustReturn: [PostData(post_id: "", product_id: "신디", content: "", createdAt: "", creator: CreatorInfo(user_id: "", nick: "", profileImage: ""), files: [""], likes: [""], comments: [CommentData(comment_id: "", content: "", createdAt: "", creator: CreatorInfo(user_id: "", nick: "", profileImage: ""))])]), postDataError: postDataError.asDriver(onErrorJustReturn: .code500), deletePostID: input.deletePostID.asDriver(), viewWillAppearTrigger: deletePostSuccess.asDriver(onErrorJustReturn: ()))
    }
}
