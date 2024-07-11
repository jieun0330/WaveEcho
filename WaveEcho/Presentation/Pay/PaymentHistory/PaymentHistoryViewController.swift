//
//  PaymentHistoryViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import UIKit

final class PaymentHistoryViewController: BaseViewController {
    
    private let mainView = PaymentHistoryView()
    private let viewModel = PaymentHistoryViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "결제 내역"
    }
    
    override func bind() {
        
        let viewWillAppearTrigger = rx.viewWillAppear
            .map { $0 == true }
        
        let input = PaymentHistoryViewModel.Input(viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.payHistorySuccess.asObservable()
            .bind(to: mainView.tableView.rx.items(cellIdentifier: PaymentHistoryTableViewCell.identifer,
                                                  cellType: PaymentHistoryTableViewCell.self)) { row, item, cell in
                
                let date = DateFormatManager.shared.stringToString(date: item.paidAt)
                cell.date.text = date
            }
                                                  .disposed(by: disposeBag)
    }
}
