//
//  EditProfileViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let editButtonTapped: ControlEvent<Void>
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
//            .withLatestFrom(input.editNickname)
//            .flatMapLatest { nickname in
//                
//                let editMyProfileRequest = EditMyProfileRequestBody(nick: nickname, phoneNum: "", birthDay: "", profile: nil)
//                
//                return APIManager.shared.editProfile(query: editMyProfileRequest)
//            }
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let success):
//                    editProfileSuccess.accept(success)
//                    editProfileSuccessTrigger.accept(())
//                case .failure(let error):
//                    editProfileError.accept(error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(editProfileSuccess: editProfileSuccess.asDriver(onErrorJustReturn: EditMyProfileResponse(user_id: "", email: "", nick: "", followers: [Followers(user_id: "", nick: "", profileImage: "")], following: [Following(user_id: "", nick: "", profileImage: "")], posts: [""])), editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500), editProfileSuccessTrigger: editProfileSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
