//
//  MyPostViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        // 포스트 삭제
        let deleteTrigger: PublishRelay<PostData>
    }
    
    struct Output {
        let postDataSuccess: Driver<[PostData]>
        let postDataError: Driver<APIError>
        // 프로필 조회 성공
        let profileSuccess: Driver<ProfileModel>
        // 프로필 조회 실패
        let profileError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        let postDataSuccess = BehaviorRelay<[PostData]> (value: [])
        let postDataError = PublishRelay<APIError>()
        // 포스트 삭제
        let deletePostError = PublishRelay<APIError>()
        // 프로필 조회 성공
        let profileSuccess = PublishRelay<ProfileModel>()
        // 프로필 조회 실패
        let profileError = PublishRelay<APIError>()
        
        input.viewDidLoad
            .flatMapLatest { _ in
                return APIManager.shared.create(type: PostModel.self,
                                                router: PostsRouter.userPost(id: UserDefaultsManager.shared.userID))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    let mapping = success.data.enumerated().map { index, model -> PostData in
                        var changedModel = model
                        // 인덱스 값 설정
                        changedModel.countTrigger(index)
                        return changedModel
                    }
                    postDataSuccess.accept(mapping)
                case .failure(let error):
                    postDataError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMapLatest { _ in
                return APIManager.shared.create(type: ProfileModel.self,
                                                router: ProfileRouter.myProfile)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    profileSuccess.accept(success)
                case .failure(let error):
                    profileError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 포스트 삭제
        input.deleteTrigger
            .flatMapLatest { postData in

                var value = postDataSuccess.value
                let index = postData.currentLocation

                value.remove(at: index)
                postDataSuccess.accept(value)
                return APIManager.shared.create(type: PostModel.self,
                                                router: PostsRouter.deletePost(id: postData.post_id))
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
        
        return Output(postDataSuccess: postDataSuccess.asDriver(), postDataError: postDataError.asDriver(onErrorJustReturn: .code500), profileSuccess: profileSuccess.asDriver(onErrorJustReturn: ProfileModel(user_id: "", email: "", nick: "", profileImage: "", posts: [])), profileError: profileError.asDriver(onErrorJustReturn: .code500))
    }
}
