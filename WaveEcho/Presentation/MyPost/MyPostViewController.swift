//
//  MyPostViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MyPostViewController: BaseViewController {
    
    private let mainView = MyPostView()
    private let viewModel = MyPostViewModel()
    private var postData: [PostData] = []
    // 내 프로필 조회 화면
    let myProfileView = AfterMyProfileViewController()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = mainView.myPageButton
    }
    
    override func uiBind() {
        // 내 프로필 modal 띄우기
        mainView.myPageButton.rx.tap
            .bind(with: self) { owner, _ in
                if let sheet = owner.myProfileView.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
                owner.present(owner.myProfileView, animated: false)
                // 내 프로필 닉네임 -> 재확인 필요
                owner.myProfileView.mainView.nickname.text = owner.postData.first?.creator.nick
            }
            .disposed(by: disposeBag)
        
        myProfileView.mainView.editNicknameButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
                vc.mainView.nicknameTextField.text = owner.postData.first?.creator.nick
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = MyPostViewModel.Input(viewDidLoad: Observable.just(Void()),
                                          deletePostID: BehaviorRelay(value: ""))
        
        let output = viewModel.transform(input: input)
        
        output.postDataSuccess.asObservable()
            .bind(with: self) { owner, postData in
                owner.postData = postData
            }
            .disposed(by: disposeBag)
        
        output.postDataSuccess.asObservable()
            .map { $0 }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier,
                                                  cellType: MyPostTableViewCell.self)) { row, item, cell in
                cell.contents.text = item.content
                let stringDate = DateFormatManager.shared.stringToDate(date: item.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                cell.date.text = relativeDate
                cell.selectionStyle = .none
                
                cell.contentImage.kf.setImage(with: URL(string: item.files?.first ?? ""))
                
                if let contentImageUrl = URL(string: item.files?.first ?? "") {
                    cell.contentImage.kf.setImage(with: contentImageUrl, options: [.requestModifier(KingFisherNet())])
                } else {
                    cell.contentImage.image = .whitePaper
                }
                input.deletePostID.accept(item.post_id)
            }
                                                  .disposed(by: disposeBag) 
        
//        output.viewWillAppearTrigger.asObservable()
//            .bind(with: self) { owner, _ in
//                owner.viewWillAppear(true)
//            }
//            .disposed(by: disposeBag)
    }
}
