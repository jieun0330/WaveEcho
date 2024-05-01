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
    
    var postData: PostData!
    
    override func loadView() {
        view = mainView
        
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        mainView.collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    override func configureView() {
        
        view.backgroundColor = .black.withAlphaComponent(0.3)        
    }
    
    func setModel(_ model: PostData) {
        let behaviorModel = BehaviorRelay(value: model)
        
        behaviorModel
            .compactMap { $0 }
            .map({ $0.comments })
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: CommentCollectionViewCell.identifier, cellType: CommentCollectionViewCell.self)) { row, item, cell in
                cell.commentUserProfileImage.kf.setImage(with: URL(string: item.creator.profileImage ?? ""), options: [.requestModifier(KingFisherNet())])
                cell.commentUserNickname.text = item.creator.nick
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
    deinit {
        print(self)
    }
}
