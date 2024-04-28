//
//  ProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyProfileViewController: BaseViewController {
    
    let mainView = MyProfileView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.editNicknameButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
                vc.mainView.nicknameTextField.text = owner.mainView.nickname.text
            }
            .disposed(by: disposeBag)
    }    
}
