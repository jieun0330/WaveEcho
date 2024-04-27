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
import PhotosUI

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
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    @objc private func photoButtonTapped() {
        print(#function)
    }
    
    override func configureView() {
        navigationItem.backButtonTitle = ""
    }
    
    override func bind() {
        let input = ContentViewModel.Input(content: mainView.contentTextView.rx.text.orEmpty,
                                                  uploadPhotoButtonTapped: mainView.uploadPhotoButton.rx.tap,
                                                  completeButtonTapped: mainView.sendButton.rx.tap)

        let output = viewModel.transform(input: input)
        
        output.createPostTrigger
            .drive(with: self) { owner, _ in
                print("포스팅 업로드 성공")
                owner.view.makeToast("포스팅 업로드 성공")
            }
            .disposed(by: disposeBag)
        
        output.createPostTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.uploadPhotoButtonTapped
            .drive(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 1
                configuration.filter = .any(of: [.images])
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
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

extension ContentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.mainView.presentPhotoView.image = image as? UIImage
                }
            }
        }
    }
}
