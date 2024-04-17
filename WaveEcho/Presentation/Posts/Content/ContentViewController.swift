//
//  ContentViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ContentViewController: BaseViewController {
    
    private let mainView = ContentView()
    private let viewModel = ContentViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "유리병 던지기"
        mainView.uploadPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func photoButtonTapped() { }
    
    override func bind() {
        let contentInput = ContentViewModel.Input(content: mainView.content.rx.text.orEmpty,
                                                  uploadButtonTapped: mainView.completeButton.rx.tap)
        
        let contentOutput = viewModel.transform(input: contentInput)
        
        contentOutput.uploadPostTrigger
            .drive(with: self) { owner, _ in
                print("포스팅 업로드 성공")
            }
            .disposed(by: disposeBag)
    }
}
