//
//  PostsDetailViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostsDetailViewController: BaseViewController {
    
    let mainView = PostsDetailView()

    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
