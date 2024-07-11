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
        
    }
    
    override func bind() {
        
        let input = EditProfileViewModel.Input(viewDidLoad: Observable.just(Void()),
                                               editNickname: mainView.nicknameTextField.rx.text.orEmpty,
                                               editImageButtonTapped: mainView.imageEditButton.rx.tap,
                                               editButtonTapped: PublishRelay<EditMyProfileRequestBody>())
        
        let output = viewModel.transform(input: input)
        
        output.profileSuccess
            .drive(with: self) { owner, myProfile in
                owner.mainView.setData(myProfile)
            }
            .disposed(by: disposeBag)
        
        output.editProfileSuccess
            .drive(with: self) { owner, value in
                
                let alertTitle = value ? "프로필 수정 완료" : "프로필 수정 실패"
                owner.makeAlert(alertTitle: "", alertMessage: alertTitle) { _ in
                    owner.pop(owner)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.imageEditButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                owner.present(nowVC: owner, toVC: vc)
            }
            .disposed(by: disposeBag)

        
        mainView.editDoneButton.rx.tap
            .withUnretained(self)
            .map { owner, _ -> EditMyProfileRequestBody in
                let nick = owner.mainView.nicknameTextField.text

                guard let profile = owner.mainView.profileImg.image,
                      let data = profile.imageZipLimit(zipRate: 4.9) else {
                    return EditMyProfileRequestBody(nick: nick ?? "", profile: nil)
                }
                
                return EditMyProfileRequestBody(nick: nick ?? "", profile: data )
            }
            .bind { model in //  EditMyProfileRequestBody
                input.editButtonTapped.accept(model)
            }
            .disposed(by: disposeBag)
       
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.mainView.profileImg.image = pickedImage
        }
        dismiss(animated: true)
    }
}
