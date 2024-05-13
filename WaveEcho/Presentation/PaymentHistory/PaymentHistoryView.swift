//
//  PaymentHistoryView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import UIKit
import SnapKit

final class PaymentHistoryView: BaseView {
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(PaymentHistoryTableViewCell.self,
                    forCellReuseIdentifier: PaymentHistoryTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [tableView].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
