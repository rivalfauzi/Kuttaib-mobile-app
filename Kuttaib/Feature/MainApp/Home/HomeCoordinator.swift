//
//  HomeCoordinator.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import UIKit

final class HomeCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let presenter = HomePresenter(coordinator: self)
        let vc = HomeViewController(presenter: presenter)

        navigationController.setViewControllers([vc], animated: false)
    }
}
