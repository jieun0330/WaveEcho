//
//  WelcomeViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import UIKit

final class WelcomeViewController: BaseViewController {
    
    private let mainView = WelcomeView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
