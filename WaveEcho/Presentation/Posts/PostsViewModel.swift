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
    }
    
    struct Output {
        let postsContent: PublishRelay<ReadPostsResponse>
        let postsError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let postsContent = PublishRelay<ReadPostsResponse>()
        let postsError = PublishRelay<APIError>()
        let fetchPostsObservable = Observable.just(FetchPostQuery(next: "",
                                                                  limit: "5",
                                                                  product_id: ""))
        input.viewDidLoad
            .withLatestFrom(fetchPostsObservable)
            .flatMap { postQuery in
                return APIManager.shared.create(type: ReadPostsResponse.self,
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
        
        return Output(postsContent: postsContent,
                      postsError: postsError.asDriver(onErrorJustReturn: .code500))
    }
}
