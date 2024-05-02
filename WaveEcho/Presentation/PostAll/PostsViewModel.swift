//
//  PostsViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let myProfileView: ControlEvent<Void>
        let viewWillAppearTrigger: Observable<Bool>
    }
    
    struct Output {
        let postsContent: PublishRelay<PostResponse>
        let postsError: Driver<APIError>
        
        let myProfile: PublishRelay<MyProfileResponse>
        let myProfileError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let postsContent = PublishRelay<PostResponse>()
        let postsError = PublishRelay<APIError>()
        let fetchPostsObservable = Observable.just(PostQueryString(next: "",
                                                                   limit: "5",
                                                                   product_id: ""))
        let myProfile = PublishRelay<MyProfileResponse>()
        let myProfileError = PublishRelay<APIError>()
        
        input.viewDidLoad
            .withLatestFrom(fetchPostsObservable)
            .flatMapLatest { postQuery in
                print("🪼🪼🪼🪼🪼", postQuery)
                return APIManager.shared.create(type: PostResponse.self,
                                                router: PostsRouter.fetchPosts(query: postQuery))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postsContent.accept(success)
                case .failure(let error):
                    postsError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.myProfileView
            .flatMap { _ in
                return APIManager.shared.create(type: MyProfileResponse.self,
                                                router: ProfileRouter.myProfile)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    myProfile.accept(success)
                case .failure(let error):
                    myProfileError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postsContent: postsContent,
                      postsError: postsError.asDriver(onErrorJustReturn: .code500),
                      myProfile: myProfile,
                      myProfileError: myProfileError.asDriver(onErrorJustReturn: .code500))
    }
}
