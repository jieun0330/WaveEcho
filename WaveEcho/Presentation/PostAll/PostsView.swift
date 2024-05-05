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
    
    lazy var seaBackgroundLottiView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "wavesAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: .max, height: .max)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 2
        animationView.play()
        return animationView
    }()
    
    private let backView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(hexCode: "1A79E9", alpha: 0.6)
        return backView
    }()
    
    let sendWaveButton = {
        let sendWave = UIButton()
        sendWave.setTitle("메아리 던지기", for: .normal)
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
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    override func configureHierarchy() {
        
        [backView, seaBackgroundLottiView, sendWaveButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        backView.snp.makeConstraints {
            $0.top.equalTo(seaBackgroundLottiView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        seaBackgroundLottiView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-200)
        }

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
