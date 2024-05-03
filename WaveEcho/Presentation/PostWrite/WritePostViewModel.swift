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
    
    var imageFiles: [String] = []
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let content: ControlProperty<String>
        let photoButtonTapped: ControlEvent<Void>
        let uploadButtonTapped: ControlEvent<Void>
        let uploadImage: PublishRelay<Data>
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
        
        // 1. 이미지 업로드
        //        input.completeButtonTapped
        //            .withLatestFrom(contentObservable)
        //            .map { writePostRequest in
        //                APIManager.shared.upload(type: ImageUploadResponse.self,
        //                                         router: PostsRouter.uploadImage,
        //                                         image: <#T##Data#>)
        //            }
        
        // 이미지 업로드
        input.uploadImage
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { data in
                return APIManager.shared.upload(type: ImageUploadResponse.self,
                                                router: PostsRouter.uploadImage,
                                                image: data)
            }
            .debug()
            .bind(with: self) { owner, result in
//                dump(result)
                switch result {
                case .success(let success):
                    print("성공????", success)
//                    guard let test = success.files else { return }
                    owner.imageFiles = success.files
                    uploadPhotoSuccess.accept(success)
                case .failure(let error):
                    dump(error)
                    print("에러 ??? ", error)
                    uploadPhotoError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.uploadButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(contentObservable)
            .flatMap { postRequest in
                print("🦂🦂🦂🦂🦂", postRequest)
                return APIManager.shared.create(type: PostResponse.self, router: PostsRouter.createPosts(query: postRequest))
            }
            .bind(with: self) { owner, result in
                print("🦧🦧🦧🦧🦧", result)
                switch result {
                case .success(let success):
                    print("🕸️🕸️🕸️🕸️🕸️", success)
                    createPostTrigger.accept(())
                case .failure(let error):
                    print("🪲🪲🪲🪲", error)
                    createPostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.photoButtonTapped
            .bind(to: uploadPhotoTrigger)
            .disposed(by: disposeBag)
        
        return Output(createPostTrigger: createPostTrigger.asDriver(onErrorJustReturn: ()),
                      createPostError: createPostError.asDriver(onErrorJustReturn: .code500),
                      uploadPhotoButtonTapped: uploadPhotoTrigger.asDriver(onErrorJustReturn: ()))
    }
}
