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
//        let editButtonTapped: ControlEvent<Void>
        let editNickname: ControlProperty<String>
    }
    
    struct Output {
        let profileSuccess: Driver<MyProfileModel>

        let editProfileSuccess: Driver<EditMyProfileModel>
        let editProfileError: Driver<APIError>
        let editProfileSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // 프로필 조회 성공
        let profileSuccess = PublishRelay<MyProfileModel>()
        
        let editProfileSuccess = PublishRelay<EditMyProfileModel>()
        let editProfileError = PublishRelay<APIError>()
        let editProfileSuccessTrigger = PublishRelay<Void>()
        
        input.viewDidLoad
            .flatMap { _ in
                return APIManager.shared.create(type: MyProfileModel.self,
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
//        input.editButtonTapped
//            .withLatestFrom(Observable.just(input.editNickname))
//            .flatMap { nickname in
//                <#code#>
//            }
//            .flatMap({ nickname in
//                let test = EditMyProfileRequestBody(nick: nickname, profile: nil)
//                return APIManager.shared.editProfile(type: EditMyProfileResponse.self, router: ProfileRouter.editMyPofile(query: <#T##EditMyProfileRequestBody#>), model: <#T##EditMyProfileRequestBody#>)
//            })
//            .flatMap { nickname in
//                print("1번", nickname)
//                let editMyProfileRequest = EditMyProfileRequestBody(nick: nickname, phoneNum: "", birthDay: "", profile: nil)
//                return APIManager.shared.editProfile(query: editMyProfileRequest, router: ProfileRouter.editMyPofile(query: editMyProfileRequest))
//            }
        
        return Output(profileSuccess: profileSuccess.asDriver(onErrorJustReturn: MyProfileModel(user_id: "", email: "", nick: "", profileImage: "", posts: [""])), editProfileSuccess: editProfileSuccess.asDriver(onErrorJustReturn: EditMyProfileModel(user_id: "", email: "", nick: "", profileImage: "", followers: [Followers(user_id: "", nick: "", profileImage: "")], following: [Following(user_id: "", nick: "", profileImage: "")], posts: [""])), editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500), editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
