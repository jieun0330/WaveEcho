//
//  PostsView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import SnapKit

class PostsView: BaseView {
    
    let segment = {
        let segment = UISegmentedControl(items: ["나의 유리병", "답장"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let myWaveView = {
        let view = UIView()
        view.tag = 0
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let responseView = {
        let view = UIView()
        view.tag = 1
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let testOfWaves = {
        let test = UIView()
        test.backgroundColor = .red
        return test
    }()
    
    let testOfWavesContents = {
        let test = UILabel()
        test.textColor = .black
        test.text = "test"
        return test
    }()
    
//    private let noWaveLabel = {
//        let noWave = UILabel()
//        noWave.text = "던진 유리병이 아직 없습니다"
//        return noWave
//    }()
    
    let sendWaveButton = {
        let sendWave = UIButton()
        sendWave.setTitle("유리병 던지기", for: .normal)
        sendWave.setTitleColor(.black, for: .normal)
        sendWave.backgroundColor = .lightGray
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
    
        segment.addTarget(self, action: #selector(didChangeValue(segment: )), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        didChangeValue(segment: segment)
    }
    
    @objc func rightBarButtonItemTapped() { }
    
    @objc func didChangeValue(segment: UISegmentedControl) {
        print(#function)
    }
    
    override func configureHierarchy() {
        [segment, testOfWaves, sendWaveButton].forEach {
            addSubview($0)
        }
        
        [testOfWavesContents].forEach {
            testOfWaves.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        segment.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        testOfWaves.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(segment.snp.bottom).offset(20)
            $0.height.equalTo(200)
        }
        
        testOfWavesContents.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
        }
        
//        noWaveLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview().inset(30)
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
