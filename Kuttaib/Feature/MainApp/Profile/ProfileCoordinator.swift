//
//  ProfileCoordinator.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import UIKit

final class ProfileCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let presenter = ProfilePresenter(coordinator: self)
        let vc = ProfileViewController(presenter: presenter)

        navigationController.setViewControllers([vc], animated: false)
    }
}
