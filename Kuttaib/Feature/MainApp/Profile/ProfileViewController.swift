//
//  ProfileViewController.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import UIKit

final class ProfileViewController: BaseViewController {
    let presenter: ProfilePresenter
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
