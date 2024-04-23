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
    
    private let withdrawAlert = {
        let alert = UIAlertController(title: "회원탙퇴",
                                      message: "정말로 회원탈퇴를 하시겠습니까?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { action in
            
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        return alert
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendWaveButton.addTarget(self,
                                          action: #selector(sendWaveButtonTapped),
                                          for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = mainView.myPageButton
        
        mainView.myPageButton.rx.tap
            .bind(with: self) {  owner, _ in
                owner.present(owner.withdrawAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rowHeight = 100
    }
    
    @objc private func sendWaveButtonTapped() {
        print(#function)
        let vc = ContentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func bind() {
        let input = PostsViewModel.Input(viewDidLoad: Observable.just(Void()))
        let output = viewModel.transform(input: input)
        
        output.postsContent
            .map { $0.data }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: PostsTableViewCell.identifer,
                                                  cellType: PostsTableViewCell.self)) {(row, element, cell) in
                
                cell.contents.text = element.content
            }
                                                  .disposed(by: disposeBag)
        
        output.postsError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .fetchPost)
            }
            .disposed(by: disposeBag)
    }
}
