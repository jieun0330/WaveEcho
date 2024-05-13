//
//  PayViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class PayViewController: BaseViewController {
    
    private let mainView = PayView()
    private let viewModel = PayViewModel()
    
//    var viewWillDisapearTrigger = false
    var paySuccessAction: ((Bool) -> Void)?
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 결제
        APIManager.shared.pay(amount: "100",
                              productTitle: "메아리",
                              webView: mainView.wkWebView) { response in
            guard let response,
                  let success = response.success else { return }
            // 결제 성공했을 때
            if success {
                self.view.makeToast("결제가 완료되었습니다", duration: 1, position: .center) { didTap in
                    UserDefaultsManager.shared.sendPost = 10
                    self.paySuccessAction?(true)
                    self.dismiss(animated: true)
                }
                self.viewModel.paymentSuccess.accept(response)
                // 결제 취소, 실패 했을 때
            } else {
                print("결제 실패")
                self.dismiss(animated: true)
            }
        }
    }
    
    override func bind() {
        let input = PayViewModel.Input(paymentSuccess: self.viewModel.paymentSuccess)
        
        let output = viewModel.transform(input: input)
        
        output.payValidationSuccess
            .drive(with: self) { owner, payResponse in
                print("payResponse.success")
            }
            .disposed(by: disposeBag)
    }
}
