//
//  PostsViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    private let viewModel = PostsViewModel()
    
//    private let withdrawAlert = {
//        let alert = UIAlertController(title: "회원탙퇴",
//                                      message: "정말로 회원탈퇴를 하시겠습니까?",
//                                      preferredStyle: .alert)
//        let yesAction = UIAlertAction(title: "네", style: .default) { action in
//            
//        }
//        let noAction = UIAlertAction(title: "아니오", style: .cancel)
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        return alert
//    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func sendWaveButtonTapped() {
        print(#function)
        let vc = WritePostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureView() {
        mainView.sendWaveButton.addTarget(self,
                                          action: #selector(sendWaveButtonTapped),
                                          for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = mainView.myPageButton
        navigationItem.title = "파도 속 유리병"
        
        mainView.myPageButton.rx.tap
            .bind(with: self) {  owner, _ in
                let vc = ProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rowHeight = 200
        
        mainView.tableView.rx.modelSelected(Contents.self)
            .bind(with: self) { owner, response in
                print("response 🖖🏻", response.content ?? "")
                let detailVC = PostsDetailViewController()
                detailVC.mainView.contents.text = response.content ?? ""
                detailVC.mainView.nickname.text = response.creator.nick
                let stringDate = DateFormatManager.shared.stringToDate(date: response.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                detailVC.mainView.date.text = relativeDate
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = PostsViewModel.Input(viewDidLoad: Observable.just(Void()))
        let output = viewModel.transform(input: input)
        
        output.postsContent
            .map { $0.data }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: PostsTableViewCell.identifer,
                                                  cellType: PostsTableViewCell.self)) {(row, element, cell) in
                print("row 🫶🏻", row)
                cell.selectionStyle = .none
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.green.cgColor

                cell.contents.text = element.content
                cell.photos.image = UIImage(named: element.files?.first ?? "")

                let stringDate = DateFormatManager.shared.stringToDate(date: element.createdAt)
                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                cell.date.text = relativeDate
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
