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
    private let viewModel = WithdrawViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.passwordTextField.delegate = self
        mainView.passwordCheckTextField.delegate = self
    }
    
    override func bind() {
        
        let input = WithdrawViewModel.Input(withdrawButtonTapped: mainView.withdrawButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.withdrawSuccess
            .drive(with: self) { owner, withdrawResponse in
                owner.view.makeToast("탈퇴되었습니다", duration: 1, position: .center) { didTap in
                    owner.setVC(WelcomeViewController())
                }
            }
            .disposed(by: disposeBag)
        
        output.withdrawError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .withdraw)
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
