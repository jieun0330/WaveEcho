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
//        let editButtonTapped: ControlEvent<Void>
        let editNickname: ControlProperty<String>
    }
    
    struct Output {
        let editProfileSuccess: Driver<EditMyProfileResponse>
        let editProfileError: Driver<APIError>
        let editProfileSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let editProfileSuccess = PublishRelay<EditMyProfileResponse>()
        let editProfileError = PublishRelay<APIError>()
        let editProfileSuccessTrigger = PublishRelay<Void>()
        
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
        
        return Output(editProfileSuccess: editProfileSuccess.asDriver(onErrorJustReturn: EditMyProfileResponse(user_id: "", email: "", nick: "", profileImage: "", followers: [Followers(user_id: "", nick: "", profileImage: "")], following: [Following(user_id: "", nick: "", profileImage: "")], posts: [""])), editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500), editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
