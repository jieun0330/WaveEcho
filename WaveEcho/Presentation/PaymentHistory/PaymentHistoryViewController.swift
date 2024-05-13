//
//  PaymentHistoryViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import UIKit

final class PaymentHistoryViewController: BaseViewController {
    
    private let mainView = PaymentHistoryView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "결제 내역"
    }
}
