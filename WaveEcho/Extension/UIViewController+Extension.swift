//
//  UIViewController+Extension.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(base.viewDidAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisapear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(base.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisapear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

extension UIViewController {
    func setVC(vc: UIViewController) {
        let vc = UINavigationController (rootViewController: vc)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func moveVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
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
