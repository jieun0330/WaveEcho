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
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = mainView.rightBarButtonItem
    }
    
    override func bind() {
        
        let input = WritePostViewModel.Input(content: mainView.contentTextView.rx.text.orEmpty,
                                             photoButtonTapped: mainView.uploadPhotoButton.rx.tap,
                                             sendButtonTapped: mainView.sendButton.rx.tap,
                                             uploadImage: imageData)
        
        let output = viewModel.transform(input: input)
        
        mainView.rightBarButtonItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // 포스팅 작성 업로드 조건
        output.validUpload
            .drive(with: self) { owner, value in
                let validButtonColor: UIColor = value ? .systemBlue : .systemGray5
                owner.mainView.sendButton.backgroundColor = validButtonColor
                let buttonTitleColor: UIColor = value ? .black : .lightGray
                owner.mainView.sendButton.setTitleColor(buttonTitleColor, for: .normal)
                let isEnabled: Bool = value ? true : false
                owner.mainView.sendButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        // 포스팅 작성 성공 -> toast 창
        output.createPostTrigger
            .drive(with: self) { owner, _ in
                owner.view.makeToast("메아리를 던졌어요!", duration: 1)
                // 작성할 때 메아리 횟수 하나씩 줄이기
                let tapCount = UserDefaultsManager.shared.sendPost - 1
                UserDefaultsManager.shared.sendPost = tapCount
            }
            .disposed(by: disposeBag)
        
        // 포스팅 작성 성공 -> pop
        output.createPostTrigger
            .debounce(.seconds(2))
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 이미지 업로드
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
//        output.createPostError
//            .drive(with: self) { owner, error in
//                owner.errorAlert(error: error, callType: .createPosts)
//            }
//            .disposed(by: disposeBag)
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
                    let compressedImgData = realImage?.imageZipLimit(zipRate: 0.3)
                    if let imageData = compressedImgData {
                        self.imageData.accept(imageData)
                        self.mainView.presentPhotoView.image = realImage
                    }
                }
            }
        }
    }
}
