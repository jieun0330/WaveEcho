//
//  PaymentHistoryView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import UIKit
import SnapKit

final class PaymentHistoryView: BaseView {
    
    private let date = {
        let date = UILabel()
        date.text = "2024년 5월 13일"
        return date
    }()
    
    private let icon = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "ellipsis.message.fill")
        return icon
    }()
    
    private let product = {
        let product = UILabel()
        product.text = "메아리"
        return product
    }()
    
    private let money = {
        let money = UILabel()
        money.text = "100원"
        return money
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [date, icon, product, money].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        date.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        icon.snp.makeConstraints {
            $0.leading.equalTo(date)
            $0.top.equalTo(date.snp.bottom).offset(10)
            $0.size.equalTo(40)
        }
        
        product.snp.makeConstraints {
            $0.centerY.equalTo(icon)
            $0.leading.equalTo(icon.snp.trailing).offset(10)
        }
        
        money.snp.makeConstraints {
            $0.centerY.equalTo(product)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
