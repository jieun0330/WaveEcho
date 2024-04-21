//
//  BaseViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureView() { }
    func bind() { }
    
    func errorHandler(apiError: APIError, calltype: APIError.CallType) {
        switch calltype {
        case .login:
            switch apiError {
            case .code400:
                makeAlert(message: "이메일 혹은 비밀번호를 올바르게 입력해주세요")
            case .code401:
                makeAlert(message: "가입되지 않았거나 비밀번호가 틀렸습니다")
            default:
                return
            }
        }
    }

    func makeAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
