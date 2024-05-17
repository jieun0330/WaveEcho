//
//  PostsViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class PostsViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Bool>
    }
    
    struct Output {
        let postSuccess: Driver<PostResponse>
        let postError: Driver<APIError>
        
        let myProfile: Driver<MyProfileResponse>
        let myProfileError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let postSuccess = PublishRelay<PostResponse>()
        let postError = PublishRelay<APIError>()
        let fetchPostsObservable = Observable.just(PostQueryString(next: "",
                                                                   limit: "10",
                                                                   product_id: "신디"))
        let myProfile = PublishRelay<MyProfileResponse>()
        let myProfileError = PublishRelay<APIError>()
        
        input.viewWillAppearTrigger
            .withLatestFrom(fetchPostsObservable)
            .flatMapLatest { postQuery in
                return APIManager.shared.create(type: PostResponse.self,
                                                router: PostsRouter.fetchPosts(query: postQuery))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postSuccess.accept(success)
                case .failure(let error):
                    postError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
//        input.myProfileView
//            .flatMap { _ in
//                return APIManager.shared.create(type: MyProfileResponse.self,
//                                                router: ProfileRouter.myProfile)
//            }
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let success):
//                    myProfile.accept(success)
//                case .failure(let error):
//                    myProfileError.accept(error)
//                }
//            }
//            .disposed(by: disposeBag)
//        
        return Output(postSuccess: postSuccess.asDriver(onErrorJustReturn: PostResponse(data: [PostData(post_id: "", product_id: "", content: "", createdAt: "", creator: CreatorInfo(user_id: "", nick: "", profileImage: ""), files: [""], comments: [CommentData(comment_id: "", content: "", createdAt: "", creator: CreatorInfo(user_id: "", nick: "", profileImage: ""))])])),
                      postError: postError.asDriver(onErrorJustReturn: .code500),
                      myProfile: myProfile.asDriver(onErrorJustReturn: MyProfileResponse(user_id: "", email: "", nick: "", profileImage: "", posts: [""])),
                      myProfileError: myProfileError.asDriver(onErrorJustReturn: .code500))
    }
}
