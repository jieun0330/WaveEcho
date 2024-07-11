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

final class PopupViewController: BaseViewController {
    
    let mainView = PopupView()
    let replyView = ReplyViewController()
    let behaviorModel = BehaviorRelay(value: PostData(post_id: "", product_id: "신디", content: "", createdAt: "", creator: CreatorInfo(user_id: "", nick: "", profileImage: ""), files: [], comments: []))
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        replyView.delegate = self
        mainView.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disposeBag = .init()
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width / 1.2, height: width / 7)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing,
                                           left: spacing,
                                           bottom: spacing,
                                           right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    func setData(_ data: PostData) {
        behaviorModel.accept(data)
        
        behaviorModel
            .bind(with: self) { owner, post in
                // 작성자 프로필 이미지
                if let profileImageUrl = URL(string: post.creator.profileImage ?? "") {
                    owner.mainView.profileImage.kf.setImage(with: profileImageUrl, options: [.requestModifier(KingFisherNet())])
                } else {
                    owner.mainView.profileImage.image = .profileImg
                }
                // 작성자 닉네임
//                owner.mainView.nicknameLabel.text = post.creator.nick
                owner.mainView.nicknameLabel.setTitle(post.creator.nick, for: .normal)

                // 작성자 콘텐츠 내용
                owner.mainView.contentLabel.text = post.content
                // 작성자 작성 시간
                let stringDate = DateFormatManager.shared.stringToDate(date: post.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                owner.mainView.date.text = relativeDate
                // 작성자 콘텐츠 이미지
                if let contentImageUrl = URL(string: post.files?.first ?? "") {
                    owner.mainView.contentImage.kf.setImage(with: contentImageUrl, options: [.requestModifier(KingFisherNet())])
                } else {
                    owner.mainView.contentImage.image = .paperboat
                }

            }
            .disposed(by: disposeBag)
        
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
        
        replyView.postID.accept(data.post_id)
        
        // 던지기 버튼
        mainView.throwButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 답장 버튼
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
}

extension PopupViewController: fetchComment {
    func fetchDone(data: CommentData) {
        var value = behaviorModel.value
        value.comments.insert(data, at: 0)
        behaviorModel.accept(value)
    }
}
