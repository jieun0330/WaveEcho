//
//  MyPostViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let deletePostID: BehaviorRelay<String> // publish
        // 포스트 삭제
        let deleteTrigger: PublishRelay<PostData>
    }
    
    struct Output {
        let postDataSuccess: Driver<[PostData]> // hot&cold observable
        let postDataError: Driver<APIError>
        let deletePostID: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let postDataSuccess = BehaviorRelay<[PostData]> (value: [])
        let postDataError = PublishRelay<APIError>()
        // 포스트 삭제
        let deletePostError = PublishRelay<APIError>() // postDataError와 다른점은?
        
        input.viewDidLoad
            .flatMap { _ in // flatMap vs flatMapLatest
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
        input.deleteTrigger
            .flatMap { postData in

                var value = postDataSuccess.value
                let index = postData.currentLocation

                value.remove(at: index)
                postDataSuccess.accept(value)
                return APIManager.shared.create(type: PostResponse.self, router: PostsRouter.deletePost(id: postData.post_id)) // Single?
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postDataSuccess.accept(success.data)
                case .failure(let error):
                    deletePostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postDataSuccess: postDataSuccess.asDriver(),
                      postDataError: postDataError.asDriver(onErrorJustReturn: .code500),
                      deletePostID: input.deletePostID.asDriver())
    }
}
