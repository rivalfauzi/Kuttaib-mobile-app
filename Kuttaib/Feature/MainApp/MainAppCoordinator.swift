//
//  MainAppCoordinator.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import UIKit

class MainAppCoordinator {
    let navigation: UINavigationController
    let mainCoordinator: MainCoordinator
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        self.navigation = mainCoordinator.navigationController
    }
    
    enum SetTargetButtonTapped {
        case back
    }
    
    func start() {
        let vc = MainTabBarController(coordinator: self)
        navigation.isNavigationBarHidden = true
        navigation.setViewControllers([vc], animated: true)
    }
    
    func navigate(_ type: SetTargetButtonTapped) {
        switch type {
        case .back:
            mainCoordinator.navigate(to: .back)
        }
    }
}
