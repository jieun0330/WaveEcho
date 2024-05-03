//
//  ProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class MyProfileViewController: BaseViewController {
    
    let mainView = MyProfileView()
    //    var myProfileResponse: MyProfileResponse!
    //    var myProfileResponse: BehaviorRelay(value: MyProfileResponse)
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "내 프로필"
    }
    
    override func uiBind() {
        
        mainView.editNicknameButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
                vc.mainView.nicknameTextField.text = owner.mainView.nickname.text
            }
            .disposed(by: disposeBag)
        
        mainView.withDrawButton.rx.tap
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "회원탈퇴",
                                              message: "정말로 회원탈퇴를 하시겠습니까?",
                                              preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "네", style: .default) {_ in
                    // 네를 눌렀을 시 회원탈퇴 진행
                }
                let noAction = UIAlertAction(title: "아니오", style: .cancel)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        //        mainView.withDrawButton.rx.tap
        //            .flatMap { _ in
        //                return APIManager.shared.create(type: WithdrawResponse.self, router: UsersRouter.withdraw)
        //            }
        //            .bind(with: self) { owner, result in
        //                switch result {
        //                case .success(_):
        //                    owner.view.makeToast("탈퇴되었습니다")
        //                case .failure(let error):
        //                    owner.errorHandler(apiError: error, calltype: .withdraw)
        //                }
        //            }
        //            .disposed(by: disposeBag)
    }
}
