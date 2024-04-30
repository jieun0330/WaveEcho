//
//  PostsViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    private let viewModel = PostsViewModel()
    // 내 프로필 조회 화면
    let vc = MyProfileViewController()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        
        navigationItem.rightBarButtonItem = mainView.myPageButton
        navigationItem.title = "파도 속 유리병"
        
        // 포스팅 작성 화면 전환
        mainView.sendWaveButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WritePostViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 내 프로필 조회 화면 전환
        mainView.myPageButton.rx.tap
            .bind(with: self) {  owner, _ in
                owner.navigationController?.pushViewController(owner.vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 포스팅 디테일 화면 전환
        mainView.tableView.rx.modelSelected(PostData.self)
            .bind(with: self) { owner, response in
                let detailVC = DetailPostViewController()
                detailVC.mainView.contents.text = response.content ?? ""
                detailVC.mainView.nickname.text = response.creator.nick
                
                detailVC.mainView.image.kf.setImage(with: URL(string: response.files?.first ?? ""), options: [.requestModifier(KingFisherNet())])
                
                let stringDate = DateFormatManager.shared.stringToDate(date: response.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                detailVC.mainView.date.text = relativeDate
                
                owner.navigationController?.pushViewController(detailVC, animated: true)
                
                detailVC.postID = response.post_id
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rowHeight = 200
    }
    
    override func bind() {
        
        let viewWillAppearTrigger = rx.viewWillAppear
            .map { $0 == true }
        
        let input = PostsViewModel.Input(viewDidLoad: Observable.just(Void()),
                                         myProfileView: mainView.myPageButton.rx.tap,
                                         viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        // 내 ㅍ
        output.myProfile
            .map { $0 }
            .bind(with: self) { owner, myProfileResponse in
                owner.vc.mainView.nickname.text = myProfileResponse.nick
            }
            .disposed(by: disposeBag)
        
        output.postsContent
            .map { $0.data }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: PostsTableViewCell.identifer,
                                                  cellType: PostsTableViewCell.self)) {(row, element, cell) in
                cell.selectionStyle = .none
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.green.cgColor
                
                cell.contents.text = element.content
                
                let stringDate = DateFormatManager.shared.stringToDate(date: element.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                cell.date.text = relativeDate
                
                guard let imageURL = element.files?.first else { return }
                
                cell.photos.kf.setImage(with: URL(string: imageURL), options: [.requestModifier(KingFisherNet())])
            }
                                                  .disposed(by: disposeBag)
        
        output.postsError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .createPosts)
            }
            .disposed(by: disposeBag)
        
        // 리프레시 토큰 만료시 기존 accessToken 삭제
        // rootView 첫화면으로 전환
        output.postsError
            .debounce(.seconds(2))
            .drive(with: self) { owner, error in
                UserDefaults.standard.removeObject(forKey: "accessToken")
                let vc = UINavigationController (rootViewController: WelcomeViewController ())
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
}
