//
//  PopupViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PopupViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let likeObservable: BehaviorRelay<String>
    }
    
    struct Output {
        let likeSuccess: Driver<Void>
        let likeError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let likeSuccess = BehaviorRelay(value: ())
        let likeError = PublishRelay<APIError>()
        
        input.likeObservable
            .flatMapLatest { postID in
                return APIManager.shared.create(type: LikeModel.self, router: PostsRouter.likePost(query: LikeQuery(like_status: true), id: postID))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    likeSuccess.accept(())
                case .failure(let error):
                    likeError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(likeSuccess: likeSuccess.asDriver(onErrorJustReturn: ()),
                      likeError: likeError.asDriver(onErrorJustReturn: .code500))
    }
}
