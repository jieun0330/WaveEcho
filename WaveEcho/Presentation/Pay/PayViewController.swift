//
//  PayViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/9/24.
//

import UIKit

final class PayViewController: BaseViewController {
    
    let mainView = PayView()
    
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
                print("결제 성공")
                // 결제 취소, 실패 했을 때
            } else {
                print("결제 실패")
            }
        }
    }
}
