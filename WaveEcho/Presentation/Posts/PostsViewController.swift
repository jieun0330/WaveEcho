//
//  PostsViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    
    private let withdrawAlert = {
        let alert = UIAlertController(title: "회원탙퇴",
                                      message: "정말로 회원탈퇴를 하시겠습니까?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { action in
            
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        return alert
    }()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendWaveButton.addTarget(self, action: #selector(sendWaveButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = mainView.myPageButton
        
        mainView.myPageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.present(owner.withdrawAlert, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func sendWaveButtonTapped() {
        print(#function)
        let vc = ContentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
