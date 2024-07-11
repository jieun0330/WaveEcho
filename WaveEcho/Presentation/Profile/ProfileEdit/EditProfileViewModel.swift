//
//  EditProfileViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let editNickname: ControlProperty<String>
        let editImageButtonTapped: ControlEvent<Void>
        let editButtonTapped: PublishRelay<EditMyProfileRequestBody>
    }
    
    struct Output {
        let profileSuccess: Driver<ProfileModel>
        let editProfileSuccess: Driver<Bool>
        let editProfileError: Driver<APIError>
        let editProfileSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // 프로필 조회 성공
        let profileSuccess = PublishRelay<ProfileModel>()
        let editProfileSuccess = PublishRelay<Bool>()
        let editProfileError = PublishRelay<APIError>()
        let editProfileSuccessTrigger = PublishRelay<Void>()
        
        input.viewDidLoad
            .flatMap { _ in
                return APIManager.shared.create(type: ProfileModel.self,
                                                router: ProfileRouter.myProfile)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    profileSuccess.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
                
        input.editButtonTapped
            .flatMap { query in
                return APIManager.shared.uploadProfile(query: query)
            }
            .bind(with: self) { owner, model in
                UserDefaultsManager.shared.nickname = model.nick
                
                if let imageString = model.profileImage {
                    let result =  imageString
                    UserDefaultsManager.shared.profileImg = result
                }
                // 있을때만 baseurl을 넣어줌
                editProfileSuccess.accept(true)
            }
            .disposed(by: disposeBag)

        return Output(profileSuccess: profileSuccess.asDriver(onErrorJustReturn: ProfileModel(user_id: "", email: "", nick: "", profileImage: "", posts: [""])), editProfileSuccess: editProfileSuccess.asDriver(onErrorJustReturn: true), editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500), editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}

