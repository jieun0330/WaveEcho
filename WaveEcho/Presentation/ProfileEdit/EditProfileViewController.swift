//
//  EditProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/29/24.
//

import UIKit

final class EditProfileViewController: BaseViewController {
    
    let mainView = EditProfileView()
    private let viewModel = EditProfileViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.editButton
    }
    
    override func uiBind() {
        //        mainView.editButton.rx.tap
        //            .bind(with: self) { owner, _ in
        //                owner.navigationController?.popViewController(animated: true)
        //            }
        //            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = EditProfileViewModel.Input(editButtonTapped: mainView.editButton.rx.tap,
                                               editNickname: mainView.nicknameTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.editProfileError.asObservable()
            .bind(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .editMyProfile)
            }
            .disposed(by: disposeBag)
    }
}