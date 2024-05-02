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
//    let myProfileView = AfterMyProfileViewController()
    
//    lazy var messageLottiView : LottieAnimationView = {
//        let animationView = LottieAnimationView(name: "messageAnimation")
//        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
////        animationView.center = center
//        animationView.contentMode = .scaleAspectFill
//        animationView.loopMode = .autoReverse
//        animationView.animationSpeed = 0.5
//        animationView.layer.borderColor = UIColor.orange.cgColor
//        animationView.layer.borderWidth = 1
//        return animationView
//    }()

    override func loadView() {
        view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        
        // 화면 크기 가져오기
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // 종이배 개수?
        let circleRadius: CGFloat = 20
        let numberOfBoat = 10
        
        let messageLottiView = mainView.messageLottiView

//        for i in 0..<2 {
            
            // 원의 x, y 좌표 계산
            let x = Int.random(in: 1...(Int(screenWidth) - Int(circleRadius * 2)))
            let y = Int.random(in: 1...(Int(screenHeight) - Int(circleRadius * 2)))
            
            view.addSubview(messageLottiView)
            
            messageLottiView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(x)
                $0.top.equalToSuperview().offset(y)
                $0.size.equalTo(CGSize(width: Int.random(in: 60...100), height: Int.random(in: 60...100)))
            }
//        }
    }
    
    override func configureView() {
        
        mainView.seaBackgroundLottiView.play()
        mainView.messageLottiView.play()
//        mainView.messageLottiView2.play()
        
        // 종이 배 클릭 시
        mainView.messageLottiView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        mainView.messageLottiView.addGestureRecognizer(tapGesture)
        
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
        
        navigationItem.rightBarButtonItem = mainView.myLetters
        navigationItem.title = "파도 속 유리병"
        
        // 내 포스팅 조회 화면 전환
        mainView.myLetters.rx.tap
            .bind(with: self) { owner, _ in
                let vc = MyPostViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 내 프로필 조회 화면 전환
//        mainView.myPageButton.rx.tap
//            .bind(with: self) {  owner, _ in
//                owner.navigationController?.pushViewController(owner.myProfileVC, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        // 포스팅 작성 화면 전환
        mainView.sendWaveButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WritePostViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 테이블뷰 클릭 시 데이터
        //        mainView.tableView.rx.modelSelected(PostData.self)
        //            .bind(with: self) { owner, response in
        //                let detailVC = DetailPostViewController()
        //                detailVC.mainView.contents.text = response.content ?? ""
        //                detailVC.mainView.nickname.text = response.creator.nick
        //
        //                detailVC.mainView.image.kf.setImage(with: URL(string: response.files?.first ?? ""), options: [.requestModifier(KingFisherNet())])
        //
        //                let stringDate = DateFormatManager.shared.stringToDate(date: response.createdAt)
        //                let relativeDate = DateFormatManager.shared.relativeDate(date: stringDate!)
        //                detailVC.mainView.date.text = relativeDate
        //
        //                owner.navigationController?.pushViewController(detailVC, animated: true)
        //
        //                detailVC.postID = response.post_id
        //            }
        //            .disposed(by: disposeBag)
        //
        //        mainView.tableView.rowHeight = 200
    }
    
    override func bind() {
        
        // 작성일자 실시간 변경
        let viewWillAppearTrigger = rx.viewWillAppear
            .map { $0 == true }
        
        let input = PostsViewModel.Input(viewDidLoad: Observable.just(Void()),
                                         myProfileView: mainView.myPageButton.rx.tap,
                                         viewWillAppearTrigger: viewWillAppearTrigger)
        
        let output = viewModel.transform(input: input)
        
//        output.myProfile
//            .map { $0 }
//            .bind(with: self) { owner, myProfileResponse in
//                owner.myProfileVC.mainView.nickname.text = myProfileResponse.nick
//                owner.myProfileVC.mainView.profileImage.kf.setImage(with: URL(string: myProfileResponse.profileImage ?? ""), options: [.requestModifier(KingFisherNet())])
//            }
//            .disposed(by: disposeBag)
        
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
