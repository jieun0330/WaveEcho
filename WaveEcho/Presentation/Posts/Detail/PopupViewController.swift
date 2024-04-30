//
//  MyPopupViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PopupViewController: BaseViewController {
    
    let mainView = PopupView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
    }
    
    override func configureView() {
        view.backgroundColor = .clear
        
        mainView.throwButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
