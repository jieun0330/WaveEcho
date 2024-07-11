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
    // 뷰 전환
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
    
    func present(nowVC: UIViewController, toVC: UIViewController) {
        nowVC.present(toVC, animated: true)
    }
    
    func pop (_ nowVC: UIViewController) {
        nowVC.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func validButton(_ value: Bool, button: UIButton) {
        let validButtonColor: UIColor = value ? .systemYellow : .systemGray5
        button.backgroundColor = validButtonColor
        let buttonTitleColor: UIColor = value ? .black : .lightGray
        button.setTitleColor(buttonTitleColor, for: .normal)
        let isEnabled: Bool = value ? true : false
        button.isEnabled = isEnabled
    }
}
