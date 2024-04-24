//
//  ProfileViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private let mainView = ProfileView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
