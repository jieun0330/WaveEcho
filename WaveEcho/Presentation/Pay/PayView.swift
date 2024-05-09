//
//  PayView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/9/24.
//

import UIKit
import WebKit
import SnapKit

final class PayView: BaseView {

    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(wkWebView)
    }
    
    override func configureConstraints() {
        wkWebView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
