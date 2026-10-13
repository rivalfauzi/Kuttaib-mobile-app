//
//  OnboardingCoordinator.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class OnboardingCoordinator {
    let navigationController: UINavigationController
    let mainCoordinator: MainCoordinator
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        self.navigationController = mainCoordinator.navigationController
    }
    
    func start() {
        let presenter = OnboardingPresenter(coordinator: self)
        let vc = OnboardingViewController(presenter: presenter)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigate() {
        mainCoordinator.navigate(to: .setTarget)
    }
}
