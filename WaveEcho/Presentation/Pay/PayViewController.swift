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
    private var postID: String?
    
    var paySuccessAction: ((Bool) -> Void)?
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paymentTest = PublishRelay<PaymentModel>()
        let paymentSuccess = PublishRelay<Void>()

        // postID를 받기위한 과정
        let result = APIManager.shared.create(type: PostResponse.self, router: PostsRouter.userPost(id: UserDefaultsManager.shared.userID))
        result.asObservable()
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.postID = success.data.first?.post_id
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
                
        // 1. 결제
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
                    
                    let payResponse = PaymentModel(imp_uid: response.imp_uid ?? "",
                                                         post_id: self.postID ?? "",
                                                         productName: "메아리",
                                                         price: 100)
                    paymentTest.accept(payResponse)
                }
                // 결제 취소, 실패 했을 때
            } else {
                self.dismiss(animated: true)
            }
        }
        
        // 2. 결제 영수증 검증
        paymentTest
            .flatMapLatest { payResponse in
                return APIManager.shared.paymentValidation(router: PayRouter.paymentsValidation(query: payResponse))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success():
                    paymentSuccess.accept(())
                case .failure(let error):
                    owner.errorHandler(apiError: error, calltype: .paymentValidation)
                }
            }
            .disposed(by: disposeBag)
    }
}
