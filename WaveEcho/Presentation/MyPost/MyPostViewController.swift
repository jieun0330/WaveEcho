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
import Toast

//protocol fetchPost: AnyObject {
//    func fetchDone(data: PostData)
//}

final class MyPostViewController: BaseViewController {
    
    private let mainView = MyPostView()
    private let viewModel = MyPostViewModel()
    private var postData: [PostData] = []
    // 내 프로필 조회 화면
    let myProfileView = AfterMyProfileViewController()
//    weak var delegate: fetchPost?
    
    let test = PublishRelay<UIAlertAction>()
    
    lazy var logout = UIAction(title: "로그아웃",
                               image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                               handler: { action in

        let alert = UIAlertController(title: "로그아웃 하시겠습니까?",
                                      message: "",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let yes = UIAlertAction(title: "확인", style: .destructive) { action in
            
            self.view.makeToast("로그아웃되었습니다") { didTap in
                UserDefaultsManager.shared.accessToken.removeAll()
                let vc = UINavigationController (rootViewController: LoginViewController ())
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert, animated: true)
    })
    
    lazy var withDraw = UIAction(title: "회원탈퇴",
                                 image: UIImage(systemName: "shared.with.you.slash"),
                                 handler: { action in
        let alert = UIAlertController(title: "탈퇴하시겠습니까?",
                                      message: "비밀번호 확인이 필요합니다",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let withDraw = UIAlertAction(title: "확인", style: .destructive) { action in
            let vc = WithdrawViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(withDraw)
        self.present(alert, animated: true)
    })
    
    lazy var menu: UIMenu = {
        return UIMenu(title: "", children: [logout, withDraw])
    }()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = mainView.settingButton
        navigationItem.rightBarButtonItem?.menu = menu
    }
    
    override func uiBind() {
        
        mainView.editProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
                vc.mainView.nicknameTextField.text = owner.postData.first?.creator.nick
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        
        let deleteTrigger = PublishRelay<PostData>()
        
        let input = MyPostViewModel.Input(viewDidLoad: Observable.just(Void()),
                                          deletePostID: BehaviorRelay(value: ""),
                                          deleteTrigger: deleteTrigger)
        
        let output = viewModel.transform(input: input)
        
        mainView.tableView.rx.modelDeleted(PostData.self)
            .bind(with: self) { owner, postData in
                let alert = UIAlertController(title: "게시글을 삭제하겠습니까?",
                                              message: "",
                                              preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "네", style: .default) { _ in
                    deleteTrigger.accept(postData)
                }
                let noAction = UIAlertAction(title: "아니오", style: .cancel)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.postDataSuccess.asObservable()
            .bind(with: self) { owner, postData in
                owner.postData = postData
            }
            .disposed(by: disposeBag)
        
        output.postDataSuccess.asObservable()
            .map { $0 }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier,
                                                  cellType: MyPostTableViewCell.self)) { row, item, cell in
                var item = item
                item.currentLocation = 0
                
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
            }
                                                  .disposed(by: disposeBag) 
        
//        output.viewWillAppearTrigger.asObservable()
//            .debug()
//            .bind(with: self) { owner, _ in
//                owner.view.makeToast("삭제되었습니다")
//                owner.viewWillAppear(true)
//            }
//            .disposed(by: disposeBag)
    }
}

