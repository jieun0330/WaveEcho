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
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
        uiBind()
        bind()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureView() { }
    func uiBind() { }
    func bind() { }

    func errorAlert(error: APIError, callType: APIError.CallType) {
        let message = ErrorHandler().errorHandler(apiError: error, calltype: callType)
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func makeAlert(alertTitle: String, alertMessage: String?, completeAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "확인", style: .default) { action in
            completeAction(action)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
