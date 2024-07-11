//
//  ContentViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WritePostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let content: ControlProperty<String>
        let photoButtonTapped: ControlEvent<Void>
        let sendButtonTapped: ControlEvent<Void>
        let uploadImage: PublishRelay<Data>
    }
    
    struct Output {
        let createPostTrigger: Driver<Void>
        let createPostError: Driver<APIError>
        let uploadPhotoButtonTapped: Driver<Void>
        let validUpload: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validUpload = BehaviorRelay(value: false)
        
        let createPostTrigger = PublishRelay<Void>()
        let createPostError = PublishRelay<APIError>()
        let uploadPhotoSuccess = BehaviorRelay<[String]>(value: [])
        let uploadPhotoError = PublishRelay<APIError>()
        let uploadPhotoTrigger = PublishRelay<Void>()
        
        let contentObservable = input.content.asObservable()
            .map { content in
                return WritePostsRequestBody(content: content,
                                             product_id: "신디",
                                             files: uploadPhotoSuccess.value)
            }

        // 이미지 업로드
        input.uploadImage
            .flatMap { data in
                return APIManager.shared.upload(type: ImageUploadModel.self,
                                                router: PostsRouter.uploadImage,
                                                image: data)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    uploadPhotoSuccess.accept(success.files)
                case .failure(let error):
                    dump(error)
                    uploadPhotoError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        contentObservable
            .bind(with: self) { owner, writePostRequest in
                guard let content = writePostRequest.content else { return }
                // 콘텐츠 작성 -> 사진 업로드 하면 던지기 버튼 비활성화 되어있음
                // 반대로 사진 업로드 부터 하면 던지기 버튼 활성화 됨
                if !content.isEmpty && !uploadPhotoSuccess.value.isEmpty {
                    validUpload.accept(true)
                } else {
                    validUpload.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(contentObservable)
            .flatMap { postRequest in
                return APIManager.shared.create(type: PostModel.self, router: PostsRouter.createPosts(query: postRequest))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    createPostTrigger.accept(())
                case .failure(let error):
                    // fail안에서의 success가 뜨고있는 상황
                    createPostTrigger.accept(())
                    createPostError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.photoButtonTapped
            .bind(to: uploadPhotoTrigger)
            .disposed(by: disposeBag)
        
        return Output(createPostTrigger: createPostTrigger.asDriver(onErrorJustReturn: ()),
                      createPostError: createPostError.asDriver(onErrorJustReturn: .code500),
                      uploadPhotoButtonTapped: uploadPhotoTrigger.asDriver(onErrorJustReturn: ()), validUpload: validUpload.asDriver())
    }
}
