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
    
    private var fetchPostsResponseCount = 0
    
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
            .bind(with: self) { owner, _ in
                owner.present(owner.withdrawAlert, animated: true)
            }
            .disposed(by: disposeBag)
     
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(PostsCollectionViewCell.self,
                                         forCellWithReuseIdentifier: PostsCollectionViewCell.identifer)
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
            .bind(with: self) { owner, fetchPostsResponse in
                owner.mainView.testOfWavesContents.text = fetchPostsResponse.data.first?.content
                owner.fetchPostsResponseCount = fetchPostsResponse.data.count
            }
            .disposed(by: disposeBag)
        
        output.postsError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .fetchPost)
            }
            .disposed(by: disposeBag)
    }
}

extension PostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count", fetchPostsResponseCount)
        return fetchPostsResponseCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCollectionViewCell.identifer,
                                                      for: indexPath) as! PostsCollectionViewCell
        
        cell.backgroundColor = .blue
        
        return cell
    }
}
