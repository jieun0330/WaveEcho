//
//  ReplyViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ReplyViewController: BaseViewController {
    
    private let imageData = PublishRelay<Data>()
    let mainView = ReplyView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
