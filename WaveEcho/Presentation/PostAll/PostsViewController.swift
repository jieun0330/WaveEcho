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
import SnapKit
import Lottie

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    private let viewModel = PostsViewModel()
    var postData: [PostData] = []
    // 팝업 화면
    let popupVC = PopupViewController()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = mainView.myLetters
        navigationItem.title = "파도 메아리"
        
        // 종이배 랜덤 포지션
        for _ in 0..<Int.random(in: 10...30) {
            
            lazy var messageLottiView : LottieAnimationView = {
                let animationView = LottieAnimationView(name: "messageAnimation")
                animationView.contentMode = .scaleAspectFill
                animationView.loopMode = .autoReverse
                animationView.animationSpeed = Double.random(in: 0.5...2)
                animationView.layer.borderColor = UIColor.orange.cgColor
                animationView.layer.borderWidth = 1
                return animationView
            }()
            
            view.addSubview(messageLottiView)
            
            messageLottiView.snp.makeConstraints {
                $0.leading.equalTo(view).offset(Int.random(in: 0..<Int(screenWidth) - 40))
                $0.top.equalTo(view).offset(Int.random(in: 350..<Int(screenHeight) - 100))
                $0.size.equalTo(Int.random(in: 30...100))
            }
            
            messageLottiView.play()
            // 종이 배 클릭 시
            messageLottiView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            messageLottiView.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .bind(with: self) { owner, tapGesture in
                    guard let post = owner.postData.randomElement() else { return }
                    
                    owner.popupVC.mainView.profileImage.kf.setImage(with: URL(string: post.creator.profileImage ?? ""), options: [.requestModifier(KingFisherNet())])
                    owner.popupVC.mainView.nicknameLabel.text = post.creator.nick
                    owner.popupVC.mainView.contentLabel.text = post.content
                    let stringDate = DateFormatManager.shared.stringToDate(date: post.createdAt)
                    let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
                    owner.popupVC.mainView.date.text = relativeDate
                    owner.popupVC.mainView.contentImage.kf.setImage(with: URL(string: post.files?.first ?? ""), options: [.requestModifier(KingFisherNet())])
                    owner.popupVC.setPostData(post)
                    owner.popupVC.modalPresentationStyle = .overCurrentContext
                    owner.present(owner.popupVC, animated: false)
                    owner.popupVC.replyView.mainView.toPerson.text = post.creator.nick
                }
                .disposed(by: disposeBag)
        }
    }
    
    override func uiBind() {
        // 내 포스팅 조회 화면 전환
        mainView.myLetters.rx.tap
            .bind(with: self) { owner, _ in
                let vc = MyPostViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 포스팅 작성 화면 전환
        mainView.sendWaveButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WritePostViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        
        // 작성일자 실시간 변경
        let viewWillAppearTrigger = rx.viewWillAppear
            .map { $0 == true }
        
        let input = PostsViewModel.Input(viewDidLoad: Observable.just(Void()),
                                         myProfileView: mainView.myPageButton.rx.tap,
                                         viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.postsContent
            .map { $0.data }
            .bind(with: self) { owner, postData in
                owner.postData = postData
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
                if case .success = error {
                } else {
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    let vc = UINavigationController (rootViewController: WelcomeViewController ())
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
    }
}
