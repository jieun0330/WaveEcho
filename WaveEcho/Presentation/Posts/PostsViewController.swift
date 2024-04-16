//
//  PostsViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendWaveButton.addTarget(self, action: #selector(sendWaveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sendWaveButtonTapped() {
        print(#function)
        let vc = ContentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
