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
//        
//        let hasCompletedOnboarding = UserDefaults.standard.bool(
//            forKey: "hasCompletedOnboarding"
//        )
//        
//        if hasCompletedOnboarding {
//            showMainApp()
//        } else {
//            showOnboarding()
//        }
        
        showOnboarding()
    }
}

extension MainCoordinator {
    func showOnboarding() {
        let coordinator = OnboardingCoordinator(mainCoordinator: self)
        coordinator.start()
        window.rootViewController = navigationController
    }
    
    func navigate(to: NavigateTo) {
        switch to {
        case .back:
            navigationController.popViewController(animated: true)
        case .setTarget:
            let coordinator = SetTargetCoordinator(mainCoordinator: self)
            coordinator.start()
        }
    }
}

enum NavigateTo {
    case back
    case setTarget
}
