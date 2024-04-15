//
//  BaseView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureView() { }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
