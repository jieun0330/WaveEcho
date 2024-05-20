//
//  ChatListViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ChatListViewController: BaseViewController {
    
    private let mainView = ChatListView()
    private let viewModel = ChatListViewModel()
    
    override func loadView() {
        super .loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        let input = ChatListViewModel.Input(viewDidLoad: Observable.just(Void()))
        
        let output = viewModel.transform(input: input)
        
        output.chatListSuccess.asObservable()
            .bind(to: mainView.tableView.rx.items(cellIdentifier: ChatListTableViewCell.identifer, cellType: ChatListTableViewCell.self)) { row, item, cell in
                
                if let imageURL = item.participants.first?.profileImage {
                    cell.profileImg.kf.setImage(with: URL(string: imageURL), options: [.requestModifier(KingFisherNet())])
                } else {
                    cell.profileImg.image = .paperboat
                }
                
                cell.userID.text = item.participants.first?.nick
                
            }
            .disposed(by: disposeBag)
    }
}
