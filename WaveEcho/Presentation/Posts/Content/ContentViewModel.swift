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
        let uploadPhotoButtonTapped: ControlEvent<Void>
        let completeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let createPostTrigger: Driver<Void>
        let createPostError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let uploadPostTrigger = PublishRelay<Void>()
        let createPostError = PublishRelay<APIError>()
        let uploadPhotoTrigger = PublishRelay<Void>()
        
        let contentObservable = input.content.asObservable()
            .map { content in
                return PostsRequestBody(content: content,
                                        product_id: "",
                                        files: nil)
            }
        
        input.completeButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(contentObservable)
            .flatMap { postRequest in
                return APIManager.shared.create(type: PostsResponse.self, router: PostsRouter.createPosts(query: postRequest))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    uploadPostTrigger.accept(())
                case .failure(let error):
                    
                    createPostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
//        input.uploadPhotoButtonTapped
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(<#T##second: ObservableConvertibleType##ObservableConvertibleType#>)
        
        return Output(createPostTrigger: uploadPostTrigger.asDriver(onErrorJustReturn: ()),
                      createPostError: createPostError.asDriver(onErrorJustReturn: .code500))
    }
}
