//
//  PostsView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import UIKit
import SnapKit

class PostsView: BaseView {
    
//    let segment = {
//        let segment = UISegmentedControl(items: ["나의 유리병", "답장"])
//        segment.translatesAutoresizingMaskIntoConstraints = false
//        return segment
//    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifer)
        return tableView
    }()
    
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
    
    }
    
    @objc func rightBarButtonItemTapped() { }
    
//    @objc func didChangeValue(segment: UISegmentedControl) {
//        print(#function)
//    }
    
    override func configureHierarchy() {
        [tableView, sendWaveButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
//        segment.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide)
//            $0.horizontalEdges.equalToSuperview().inset(30)
//            $0.height.equalTo(40)
//        }
        
        tableView.snp.makeConstraints {
//            $0.top.equalTo(segment.snp.bottom).offset(10)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(sendWaveButton.snp.top).offset(-10)
//            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
        
        sendWaveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
//        segment.addTarget(self, action: #selector(didChangeValue(segment: )), for: .valueChanged)
//        segment.selectedSegmentIndex = 0
//        didChangeValue(segment: segment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
