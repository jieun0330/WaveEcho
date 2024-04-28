//
//  ContentViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class WritePostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var image: Data!
    var imageFiles: [String] = []
    
    struct Input {
        let content: ControlProperty<String>
        let uploadPhotoButtonTapped: ControlEvent<Void>
        let completeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let createPostTrigger: Driver<Void>
        let createPostError: Driver<APIError>
        let uploadPhotoButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let createPostTrigger = PublishRelay<Void>()
        let createPostError = PublishRelay<APIError>()
        
        let uploadPhotoSuccess = PublishRelay<ImageUploadResponse>()
        let uploadPhotoError = PublishRelay<APIError>()
        let uploadPhotoTrigger = PublishRelay<Void>()
        
        let contentObservable = input.content.asObservable()
            .map { content in
                return WritePostsRequestBody(content: content,
                                        product_id: "",
                                        files: self.imageFiles)
            }
        
        input.completeButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(contentObservable)
            .flatMap { postRequest in
                return APIManager.shared.create(type: WritePostsResponse.self, router: PostsRouter.createPosts(query: postRequest))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    createPostTrigger.accept(())
                case .failure(let error):
                    print("error 🫥", error)
                    createPostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.uploadPhotoButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                return APIManager.shared.upload(type: ImageUploadResponse.self,
                                                router: PostsRouter.uploadImage,
                                                image: self.image)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.imageFiles = success.files
                    uploadPhotoSuccess.accept(success)
                case .failure(let error):
                    uploadPhotoError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.uploadPhotoButtonTapped
            .bind(to: uploadPhotoTrigger)
            .disposed(by: disposeBag)
                
        return Output(createPostTrigger: createPostTrigger.asDriver(onErrorJustReturn: ()),
                      createPostError: createPostError.asDriver(onErrorJustReturn: .code500),
                      uploadPhotoButtonTapped: uploadPhotoTrigger.asDriver(onErrorJustReturn: ()))
    }
}
