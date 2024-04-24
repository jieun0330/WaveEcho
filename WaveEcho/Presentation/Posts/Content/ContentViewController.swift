//
//  ContentViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class ContentViewController: BaseViewController {
    
    private let mainView = ContentView()
    private let viewModel = ContentViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "유리병 던지기"
//        mainView.uploadPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
    }
    
//    @objc private func photoButtonTapped() { }
    
    override func bind() {
        let contentInput = ContentViewModel.Input(content: mainView.content.rx.text.orEmpty,
                                                  uploadPhotoButtonTapped: mainView.uploadPhotoButton.rx.tap,
                                                  completeButtonTapped: mainView.completeButton.rx.tap)
        
        let contentOutput = viewModel.transform(input: contentInput)
        
        contentOutput.createPostTrigger
            .drive(with: self) { owner, _ in
                print("포스팅 업로드 성공")
                owner.view.makeToast("포스팅 업로드 성공")
            }
            .disposed(by: disposeBag)
        
        contentOutput.createPostTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 포스팅 작성 에러 핸들링
//        contentOutput.createPostError
//            .drive(with: self) { owner, error in
//                owner.errorHandler(apiError: error, calltype: .createPosts)
//            }
//            .disposed(by: disposeBag)
    }
}
