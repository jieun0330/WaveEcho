//
//  ChatListView.swift
//  WaveEcho
//
//  Created by 박지은 on 5/19/24.
//

import UIKit
import SnapKit

final class ChatListView: BaseView {
    
    let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .yellow
        tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: ChatListTableViewCell.identifer)
        tableView.rowHeight = 100
        return tableView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    override func configureHierarchy() {
        [tableView].forEach {
            addSubview($0)
        }
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
