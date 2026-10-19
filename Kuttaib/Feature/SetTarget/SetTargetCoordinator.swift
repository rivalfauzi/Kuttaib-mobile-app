//
//  SetTargetCoordinator.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class SetTargetCoordinator {
    let navigation: UINavigationController
    let mainCoordinator: MainCoordinator
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        self.navigation = mainCoordinator.navigationController
    }
    
    enum SetTargetButtonTapped {
        case back
        case skip
        case confirm([MainTargetEntity])
        case home
    }
    
    func start() {
        let presenter = SetTargetPresenter(coordinator: self)
        let vc = SetTargetContainerViewController(presenter: presenter)
        navigation.pushViewController(vc, animated: true)
    }
    
    func navigate(_ type: SetTargetButtonTapped) {
        switch type {
        case .back:
            mainCoordinator.navigate(to: .back)
        case .skip:
            break
        case .confirm(let data):
            let presenter = ConfirmTargetPresenter(coordinator: self, data: data)
            let vc = ConfirmTargetViewController(presenter: presenter)
            navigation.pushViewController(vc, animated: true)
        case .home:
            mainCoordinator.navigate(to: .mainApp)
        }
    }
}
