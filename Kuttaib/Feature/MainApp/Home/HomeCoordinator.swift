//
//  HomeCoordinator.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import UIKit

final class HomeCoordinator {
    let navigationController: UINavigationController
    
    enum Navigate {
        case MemorizationSession(task: TaskModel, surah: Quran.Surah.Response?)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let presenter = HomePresenter(coordinator: self)
        let vc = HomeViewController(presenter: presenter)

        navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigateTo(_ navigate: Navigate) {
        switch navigate {
        case .MemorizationSession(let task, let surah):
            let presenter = MemorizationPresenter(task: task, surah: surah)
            let vc = MemorizationViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
