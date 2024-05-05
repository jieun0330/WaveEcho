//
//  EditProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class EditProfileViewController: BaseViewController {
    
    let mainView = EditProfileView()
    private let viewModel = EditProfileViewModel()
    var profileImg: Data?
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.editButton
    }
    
    override func bind() {
        let input = EditProfileViewModel.Input(editButtonTapped: mainView.editButton.rx.tap,
                                               editNickname: mainView.nicknameTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
//        output.editProfileSuccessTrigger
//            .drive(with: self) { owner, _ in
//                owner.view.makeToast("닉네임 변경 완료")
//            }
//            .disposed(by: disposeBag)
    
        output.editProfileError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .editMyProfile)
            }
            .disposed(by: disposeBag)
    }
}
