//
//  ContentViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class ContentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let content: ControlProperty<String>
        let uploadButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let uploadPostTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let uploadPostTrigger = PublishRelay<Void>()
        
        let contentObservable = input.content.asObservable()
            .map { content in
                return PostsRequestBody(content: content,
                                        product_id: "",
                                        files: nil)
            }
        
        input.uploadButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(contentObservable)
            .flatMap { postRequest in
                return PostsRouter.createPosts(query: postRequest)
            }
            .bind(with: self) { owner, postResponse in
                uploadPostTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(uploadPostTrigger: uploadPostTrigger.asDriver(onErrorJustReturn: ()))
    }
}
