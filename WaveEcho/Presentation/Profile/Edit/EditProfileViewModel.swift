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
        let editProfileButtonTapped: ControlEvent<Void>
        let editNickname: ControlProperty<String>
    }
    
    struct Output {
        let completeEditProfile: PublishRelay<EditMyProfileResponse>
        let editProfileError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let editProfile = PublishRelay<EditMyProfileResponse>()
        let editProfileError = PublishRelay<APIError>()
        
        input.editProfileButtonTapped
            .withLatestFrom(input.editNickname)
            .flatMap { nickname in
                return APIManager.shared.create(type: EditMyProfileResponse.self,
                                                router: ProfileRouter.editMyPofile(query: EditMyProfileRequestBody(nick: nickname, phoneNum: nil, birthDay: nil, profile: nil)))
            }
            .bind(with: self) { owner, result in
                dump(result)
                switch result {
                case .success(let success):
                    editProfile.accept(success)
                    print("success 👱🏻‍♀️", success)
                case .failure(let error):
                    editProfileError.accept(error)
                    print("error 👵🏻", error)
                }
            }
            .disposed(by: disposeBag)
                
        return Output(completeEditProfile: editProfile,
                      editProfileError: editProfileError.asDriver(onErrorJustReturn: .code500))
    }
}
