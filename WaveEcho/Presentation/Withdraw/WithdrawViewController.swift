//
//  WithdrawViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class WithdrawViewController: BaseViewController {
    
    private let mainView = WithdrawView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.passwordTextField.delegate = self
        mainView.passwordCheckTextField.delegate = self
    }
    
    override func bind() {
        mainView.withdrawButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.makeToast("탈퇴되었습니다") { didTap in
                    owner.setVC(vc: WelcomeViewController())
                }
            }
            .disposed(by: disposeBag)
    }
}

extension WithdrawViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.passwordTextField {
            self.mainView.passwordCheckTextField.becomeFirstResponder()
        } else if textField == self.mainView.passwordCheckTextField {
            mainView.withdrawButton.backgroundColor = .blue
            view.endEditing(true)
            mainView.withdrawButton.isEnabled = true
        }
        return true
    }
}
