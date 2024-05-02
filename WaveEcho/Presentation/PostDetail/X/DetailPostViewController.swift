////
////  PostsDetailViewController.swift
////  WaveEcho
////
////  Created by 박지은 on 4/27/24.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//final class DetailPostViewController: BaseViewController {
//    
//    let mainView = DetailPostView()
//    let viewModel = DetailPostViewModel()
//    var postData: [PostData] = []
//    
//    override func loadView() {
//        super.loadView()
//        
//        view = mainView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func bind() {
//        
//        let viewDidAppear = rx.viewDidAppear
//            .map { $0 == true }
//        
//        guard let postID = postData.first?.post_id else { return }
//        
//        let input = DetailPostViewModel.Input(sendButtonTapped: mainView.sendButton.rx.tap,
//                                              commentContent: mainView.replyTextView.rx.text.orEmpty,
//                                              viewWillAppearTrigger: viewDidAppear,
//                                              postID: postID)
//        
//        let output = viewModel.transform(input: input)
//        
//        output.commentSuccess
//            .drive(with: self) { owner, writeCommentResponse in
//                owner.mainView.successCommentTest.text = writeCommentResponse.content
//            }
//            .disposed(by: disposeBag)
//    }
//}
