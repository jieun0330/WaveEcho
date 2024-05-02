//
//  PostsView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import SnapKit
import Lottie

class PostsView: BaseView {
    
    lazy var seaBackgroundLottiView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "wavesAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: .max, height: .max)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
//        animationView.layer.borderColor = UIColor.orange.cgColor
//        animationView.layer.borderWidth = 1
        animationView.animationSpeed = 2
        return animationView
    }()
    
    lazy var messageLottiView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "messageAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 0.5
        animationView.layer.borderColor = UIColor.orange.cgColor
        animationView.layer.borderWidth = 1
        return animationView
    }()
    
//    lazy var messageLottiView2 : LottieAnimationView = {
//        let animationView = LottieAnimationView(name: "messageAnimation")
//        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animationView.center = center
//        animationView.contentMode = .scaleAspectFill
//        animationView.loopMode = .autoReverse
//        animationView.animationSpeed = 0.5
//        animationView.layer.borderColor = UIColor.orange.cgColor
//        animationView.layer.borderWidth = 1
//        return animationView
//    }()
    
    let sendWaveButton = {
        let sendWave = UIButton()
        sendWave.setTitle("유리병 던지기", for: .normal)
        sendWave.setTitleColor(.white, for: .normal)
        sendWave.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        sendWave.layer.cornerRadius = 20
        return sendWave
    }()
    
    lazy var myLetters = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "paperplane.fill")
        return item
    }()
    
    lazy var myPageButton = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "person")
        return item
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }

    override func configureHierarchy() {
                
        [seaBackgroundLottiView, sendWaveButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        seaBackgroundLottiView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        messageLottiView2.snp.makeConstraints {
//            $0.top.equalTo(messageLottiView.snp.bottom).offset(20)
//            $0.size.equalTo(Int.random(in: 60...100))
//        }
        
        sendWaveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
