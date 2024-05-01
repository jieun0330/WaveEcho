//
//  MyPostView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import BetterSegmentedControl
import SnapKit

final class MyPostView: BaseView {
    
    private let segment = {
        let segment = BetterSegmentedControl(frame: .zero)
        segment.segments = LabelSegment.segments(withTitles: ["나의 유리병", "답장"])
        return segment
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(MyPostTableViewCell.self,
                    forCellReuseIdentifier: MyPostTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func configureHierarchy() {
        [segment, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        segment.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
