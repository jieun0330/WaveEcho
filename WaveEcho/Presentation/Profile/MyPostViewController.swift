//
//  MyPostViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import Kingfisher

final class MyPostViewController: BaseViewController {
    
    private let mainView = MyPostView()
    private let viewModel = MyPostViewModel()
    
    private lazy var logout = UIAction(title: "로그아웃",
                                       image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                       handler: { [weak self] _ in
        guard let weakSelf = self else { return }
        weakSelf.makeAlert(alertTitle: "로그아웃 하시겠습니까?", alertMessage: nil) {completeAction in
            weakSelf.view.makeToast("로그아웃되었습니다", duration: 1, position: .center) { didTap in
                UserDefaultsManager.shared.accessToken.removeAll()
                weakSelf.setVC(vc: LoginViewController())
            }
        }
    })
    
    private lazy var withDraw = UIAction(title: "회원탈퇴",
                                         image: UIImage(systemName: "person.slash"),
                                         handler: { [weak self] _ in
        guard let weakSelf = self else { return }
        weakSelf.makeAlert(alertTitle: "탈퇴하시겠습니까?", alertMessage: "비밀번호 확인이 필요합니다") { completeAction in
            weakSelf.moveVC(vc: WithdrawViewController())
        }
    })
    
    private lazy var menu: UIMenu = {
        return UIMenu(title: "", children: [logout, withDraw])
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [mainView.settingButton, mainView.paymentButton]
        navigationItem.rightBarButtonItem?.menu = menu
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.nickname.text = UserDefaultsManager.shared.nickname
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaultsManager.shared.profileImg == "" {
            mainView.profileImage.image = UIImage(resource: .profile)
        } else {
            let url = URL(string: UserDefaultsManager.shared.profileImg)
            if let url {
                mainView.profileImage.kf.setImage(with:url, options: [.requestModifier(KingFisherNet())])
            } else {
                mainView.profileImage.image = UIImage(resource: .profile)
            }
        }
    }
    
    override func bind() {
        
        // 포스트 삭제
        let deleteTrigger = PublishRelay<PostData>()
        
        let input = MyPostViewModel.Input(viewDidLoad: Observable.just(Void()), // 포스트 조회
                                          deleteTrigger: deleteTrigger)
        
        let output = viewModel.transform(input: input)
                
        output.postDataSuccess.asObservable()
            .map { $0 }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier,
                                                  cellType: MyPostTableViewCell.self)) { row, item, cell in
                cell.setData(item)
                cell.selectionStyle = .none
            }
                                                  .disposed(by: disposeBag)
        
        // 프로필 조회
        output.profileSuccess
            .drive(with: self) { owner, myProfile in
                                owner.mainView.setData(myProfile)

            }
            .disposed(by: disposeBag)
        
        // 포스트 삭제
        mainView.tableView.rx.modelDeleted(PostData.self)
            .bind(with: self) { owner, postData in
                owner.makeAlert(alertTitle: "게시글을 삭제하겠습니까?",
                                alertMessage: nil) { _ in
                    deleteTrigger.accept(postData)
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 편집
        mainView.editProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.moveVC(vc: EditProfileViewController())
            }
            .disposed(by: disposeBag)
        
        // 결제 내역
        mainView.paymentButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.moveVC(vc: PaymentHistoryViewController())
            }
            .disposed(by: disposeBag)
    }
}

