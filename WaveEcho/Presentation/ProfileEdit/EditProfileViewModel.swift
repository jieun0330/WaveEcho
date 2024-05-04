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
    }
    
    func transform(input: Input) -> Output {
        
        let editProfileSuccess = PublishRelay<EditMyProfileResponse>()
        let editProfileError = PublishRelay<APIError>()
        
        input.editButtonTapped
            .withLatestFrom(input.editNickname)
            .flatMap { nickname in
                return APIManager.shared.create(type: EditMyProfileResponse.self,
                                                router: ProfileRouter.editMyPofile(query: EditMyProfileRequestBody(nick: nickname, phoneNum: nil, birthDay: nil, profile: nil)))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    editProfileSuccess.accept(success)
                case .failure(let error):
                    editProfileError.accept(error)
                }
            }
            .disposed(by: disposeBag)
                
        return Output(editProfileSuccess: editProfileSuccess.asDriver(onErrorJustReturn: EditMyProfileResponse(user_id: "", email: "", nick: "", followers: [Followers(user_id: "", nick: "", profileImage: "")], following: [Following(user_id: "", nick: "", profileImage: "")], posts: [""])), editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500))
    }
}
