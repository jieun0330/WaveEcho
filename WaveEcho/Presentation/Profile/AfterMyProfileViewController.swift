//
//  AfterMyProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class AfterMyProfileViewController: BaseViewController {
    
    let mainView = AfterMyProfileView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func uiBind() {
        
        mainView.editNicknameButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
