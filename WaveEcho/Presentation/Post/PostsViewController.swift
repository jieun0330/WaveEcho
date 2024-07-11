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
import WebKit

final class PostsViewController: BaseViewController {
    
    private let mainView = PostsView()
    private let viewModel = PostsViewModel()
    
    private let payView = PayViewController()
    var postData: [PostData] = []
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItems = [mainView.myLetters, mainView.chat]
        navigationItem.title = "파도 메아리"
        
        // 종이배 랜덤 포지션
        for _ in 0..<Int.random(in: 10...15) {
            
            lazy var messageLottiView : LottieAnimationView = {
                let animationView = LottieAnimationView(name: "messageAnimation")
                animationView.contentMode = .scaleAspectFill
                animationView.loopMode = .autoReverse
                animationView.animationSpeed = Double.random(in: 0.5...2)
                return animationView
            }()
            
            view.addSubview(messageLottiView)
            
            messageLottiView.snp.makeConstraints {
                $0.leading.equalTo(view).offset(Int.random(in: 0..<Int(screenWidth) - 40))
                $0.top.equalTo(view).offset(Int.random(in: 350..<Int(screenHeight) - 160))
                $0.size.equalTo(Int.random(in: 30...100))
            }
            
            messageLottiView.play()
            // 종이 배 클릭 시
            messageLottiView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            messageLottiView.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    guard let post = owner.postData.randomElement() else { return }
                   
                    // 팝업 화면
                    let popupVC = PopupViewController()
                    popupVC.setData(post)
                    popupVC.replyView.mainView.toPerson.text = post.creator.nick
                    popupVC.modalPresentationStyle = .overCurrentContext
                    owner.present(popupVC, animated: false )
                }
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sendPostCount = UserDefaultsManager.shared.sendPost
        mainView.sendWaveButton.setTitle("메아리 던지기(\(sendPostCount))", for: .normal)
    }
    
    override func uiBind() {
        
        payView.paySuccessAction = { [weak self] value in
            guard let self else { return }
            let sendPostCount = UserDefaultsManager.shared.sendPost
            mainView.sendWaveButton.setTitle("메아리 던지기(\(sendPostCount))", for: .normal)
        }
        
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
                if UserDefaultsManager.shared.sendPost == 0 {
                    
                    let alert = UIAlertController(title: "메아리 횟수가 부족해요!",
                                                  message: "100원 = 메아리 10개",
                                                  preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "100원 결제하기", style: .default) {_ in
                        owner.present(owner.payView, animated: true)
                    }
                    let noAction = UIAlertAction(title: "닫기", style: .cancel)
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    owner.present(alert, animated: true)
//                }
                    
//                    owner.makeAlert(alertTitle: "메아리 횟수가 부족해요!",
//                              alertMessage: "100원 = 메아리 10개") { _ in
//                        let yesAction = UIAlertAction(title: "100원 결제하기", style: .default) {_ in
//                            owner.present(owner.payView, animated: true)
//                        }
//                        let noAction = UIAlertAction(title: "닫기", style: .cancel)
//                    }
                } else {
                    let vc = WritePostViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)        
    }
    
    override func bind() {
        
        // 작성일자 실시간 변경
        let viewWillAppearTrigger = rx.viewWillAppear
            .map { $0 == true}
        
        let input = PostsViewModel.Input(viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.postSuccess
            .map { $0.data }
            .drive(with: self) { owner, postData in
                owner.postData = postData
            }
            .disposed(by: disposeBag)
        
        // 포스팅 에러 핸들링
        output.postError
            .drive(with: self) { owner, error in
                owner.errorHandler(apiError: error, calltype: .createPosts)
            }
            .disposed(by: disposeBag)
        
        // 리프레시 토큰 만료시 기존 accessToken 삭제
        // rootView 첫화면으로 전환
        output.postError
            .debounce(.seconds(2))
            .drive(with: self) { owner, error in
                if case .success = error {
                } else {
                    UserDefaultsManager.shared.accessToken.removeAll()
                    let vc = UINavigationController (rootViewController: WelcomeViewController ())
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
    }
    deinit {
        print(self)
    }
}
