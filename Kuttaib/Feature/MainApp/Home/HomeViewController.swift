//
//  HomeViewController.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import UIKit

final class HomeViewController: BaseViewController {
    let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
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

