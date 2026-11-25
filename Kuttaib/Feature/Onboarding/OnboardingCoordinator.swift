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
    
    enum Navigation {
        case setTarget
        case confirm(CreateTargetOnboardingResponse)
        case home
    }
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        self.navigationController = mainCoordinator.navigationController
    }
    
    func start() {
        let presenter = OnboardingPresenter(coordinator: self)
        let vc = OnboardingViewController(presenter: presenter)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigate(_ to: Navigation) {
        switch to {
        case .setTarget:
            let presenter = SetTargetOnboardingPresenter(coordinator: self)
            let vc = SetTargetOnboardingView(presenter: presenter)
            navigationController.pushViewController(vc, animated: true)
        case .confirm(let data):
            let presenter = ConfirmTargetOnboardingPresenter(coordinator: self, data: data)
            let vc = ConfirmTargetOnboardingView(presenter: presenter)
            navigationController.pushViewController(vc, animated: true)
        case .home:
            mainCoordinator.navigate(to: .mainApp)
        }
    }
}
