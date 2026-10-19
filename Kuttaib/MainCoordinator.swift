//
//  MainCoordinator.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class MainCoordinator {
    private let window: UIWindow
    let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        let hasCompletedOnboarding = UserDefaults.standard.bool( forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
            showMainApp()
        } else {
            showOnboarding()
        }
    }
}

extension MainCoordinator {
    func showOnboarding() {
        let coordinator = OnboardingCoordinator(mainCoordinator: self)
        coordinator.start()
    }
    
    func showMainApp() {
        let coordinator = MainAppCoordinator(mainCoordinator: self)
        coordinator.start()
    }
    
    func navigate(to: NavigateTo) {
        switch to {
        case .back:
            navigationController.popViewController(animated: true)
        case .setTarget:
            let coordinator = SetTargetCoordinator(mainCoordinator: self)
            coordinator.start()
        case .mainApp:
            showMainApp()
        }
    }
}

enum NavigateTo {
    case back
    case setTarget
    case mainApp
}
