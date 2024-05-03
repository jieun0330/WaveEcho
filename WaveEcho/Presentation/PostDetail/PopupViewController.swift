//
//  MyPopupViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

//protocol getCommentUser: NSObject {
//    func getCommentUser(writeCommentResponse: WriteCommentResponse)
//}

final class PopupViewController: BaseViewController {
    
    let mainView = PopupView()
    let replyView = ReplyViewController()
    //    private let viewModel = PopupViewModel()
    //    var test = PublishRelay<WriteCommentResponse>()
    //    var postData: PostData!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        //        replyView.getCommentUser = self
        mainView.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = .init()
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width / 1.2, height: width / 2)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing,
                                           left: spacing,
                                           bottom: spacing,
                                           right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
    func setPostData(_ model: PostData) {
        
        let behaviorModel = BehaviorRelay(value: model)
        
        behaviorModel
            .compactMap { $0 }
            .map({ $0.comments })
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: CommentCollectionViewCell.identifier, cellType: CommentCollectionViewCell.self)) { row, item, cell in
                // 코멘트 프로필 이미지
                if let profileImageURL = item.creator.profileImage {
                    cell.commentUserProfileImage.kf.setImage(with: URL(string: profileImageURL), options: [.requestModifier(KingFisherNet())])
                } else {
                    cell.commentUserProfileImage.image = .profileImg
                }
                // 코멘트 닉네임
                cell.commentUserNickname.text = item.creator.nick
                // 코멘트 내용
                cell.commentLabel.text = item.content
            }
            .disposed(by: disposeBag)
        
        //        model.post_id
        replyView.postID = model.post_id
        
        mainView.throwButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.replyButton.rx.tap
            .bind(with: self) { owner, _ in
                if let sheet = owner.replyView.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                owner.present(owner.replyView, animated: false)
            }
            .disposed(by: disposeBag)
    }    
    deinit {
        print(self)
    }
    
    override func uiBind() {
        replyView.mainView.sendButton.rx.tap
            .bind(with: self) { owner, _ in
                print("던지기 버튼 눌렸")
            }
            .disposed(by: disposeBag)
    }
}

//extension PopupViewController : getCommentUser {
//    func getCommentUser(writeCommentResponse: WriteCommentResponse) {
//        
//        test.accept(writeCommentResponse)
//        print("🐞🐞🐞🐞🐞", writeCommentResponse)
//    }
//}
