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

final class WritePostViewController: BaseViewController {
    
    private let mainView = WritePostView()
    private let viewModel = WritePostViewModel()
    private let imageData = PublishRelay<Data>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "메아리 던지기"
//        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
        navigationItem.backButtonTitle = ""
    }
    
    override func uiBind() {
//        mainView.rightBarButtonItem.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.view.endEditing(true)
//            }
//            .disposed(by: disposeBag)
    }
        
    override func bind() {
        
        let input = WritePostViewModel.Input(content: mainView.contentTextView.rx.text.orEmpty,
                                             photoButtonTapped: mainView.uploadPhotoButton.rx.tap,
                                             uploadButtonTapped: mainView.sendButton.rx.tap,
                                             uploadImage: imageData)
        
        let output = viewModel.transform(input: input)
        
        output.createPostTrigger
            .drive(with: self) { owner, _ in
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
        output.createPostError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .createPosts)
            }
            .disposed(by: disposeBag)
    }
}

extension WritePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    let realImage = image as? UIImage
                    let imagePng = realImage?.pngData()!
                    self.imageData.accept(imagePng!)
                    self.mainView.presentPhotoView.image = image as? UIImage
                }
            }
        }
    }
}
