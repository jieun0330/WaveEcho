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
        animationView.animationSpeed = 2
        return animationView
    }()
    
    lazy var messageLottiView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "messageAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 0.5
        return animationView
    }()
    
    lazy var messageLottiView2 : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "messageAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 0.5
        return animationView
    }()
    
    //    let tableView = {
    //        let tableView = UITableView()
    //        tableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifer)
    //        return tableView
    //    }()
    
    let sendWaveButton = {
        let sendWave = UIButton()
        sendWave.setTitle("유리병 던지기", for: .normal)
        sendWave.setTitleColor(.white, for: .normal)
        sendWave.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        sendWave.layer.cornerRadius = 20
        return sendWave
    }()
    
    lazy var myPageButton = {
        let myPage = UIBarButtonItem(image: UIImage(systemName: "person"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(rightBarButtonItemTapped))
        return myPage
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    @objc func rightBarButtonItemTapped() { }
    
    override func configureHierarchy() {
        [seaBackgroundLottiView, messageLottiView, messageLottiView2, sendWaveButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        seaBackgroundLottiView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        messageLottiView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        messageLottiView2.snp.makeConstraints {
            $0.top.equalTo(messageLottiView.snp.bottom).offset(20)
            $0.size.equalTo(100)
        }
        
        //        tableView.snp.makeConstraints {
        //            $0.top.equalTo(safeAreaLayoutGuide)
        //            $0.horizontalEdges.equalToSuperview().inset(10)
        //            $0.bottom.equalTo(sendWaveButton.snp.top).offset(-10)
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
