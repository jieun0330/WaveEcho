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
        let postsContent: PublishRelay<FetchPostsResponse>
        let postsError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let postsContent = PublishRelay<FetchPostsResponse>()
        let postsError = PublishRelay<APIError>()
        let fetchPostsObservable = Observable.just(FetchPostQuery(next: "",
                                                                  limit: "5",
                                                                  product_id: ""))
        input.viewDidLoad
            .withLatestFrom(fetchPostsObservable)
            .flatMap { postQuery in
                print("postQuery💀", postQuery)
                return APIManager.shared.create(type: FetchPostsResponse.self,
                                                router: PostsRouter.fetchPosts(query: postQuery))
            }
            .bind(with: self) { owner, result in
                print("result🕵🏻‍♂️", result)
                switch result {
                case .success(let success):
                    print("success💪🏻", success)
                    postsContent.accept(success)
                    
                case .failure(let error):
                    print("error🧕🏻", error)
                    postsError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postsContent: postsContent,
                      postsError: postsError.asDriver(onErrorJustReturn: .code500))
    }
}
