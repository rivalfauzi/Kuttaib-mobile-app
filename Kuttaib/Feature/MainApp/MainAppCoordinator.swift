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
        let presenter = HomePresenter(coordinator: self)
        let vc = HomeViewController(presenter: presenter)
        
        navigation.setViewControllers([vc], animated: true)
    }
    
    func navigate(_ type: SetTargetButtonTapped) {
        switch type {
        case .back:
            mainCoordinator.navigate(to: .back)
        }
    }
}
