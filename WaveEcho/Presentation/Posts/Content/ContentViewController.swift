//
//  ContentViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit

final class ContentViewController: BaseViewController {
    
    private let mainView = ContentView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "유리병 던지기"
        mainView.uploadPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func photoButtonTapped() {
        print(#function)
    }
}
