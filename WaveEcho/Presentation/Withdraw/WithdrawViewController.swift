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
    
    override func uiBind() {
        mainView.withdrawButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.makeToast("탈퇴되었습니다") { didTap in
                    let vc = UINavigationController (rootViewController: WelcomeViewController ())
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
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

//        mainView.withDrawButton.rx.tap
//            .bind(with: self) { owner, _ in
//                let alert = UIAlertController(title: "회원탈퇴",
//                                              message: "정말로 회원탈퇴를 하시겠습니까?",
//                                              preferredStyle: .alert)
//                let yesAction = UIAlertAction(title: "네", style: .default) {_ in
//                    // 네를 눌렀을 시 회원탈퇴 진행
//                }
//                let noAction = UIAlertAction(title: "아니오", style: .cancel)
//                alert.addAction(yesAction)
//                alert.addAction(noAction)
//                owner.present(alert, animated: true)
//            }
//            .disposed(by: disposeBag)
        
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
