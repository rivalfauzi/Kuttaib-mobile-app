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
        case memorizationSession(task: TaskModel, surah: Quran.Surah.Response?)
        case targetDetail(data: TargetModel, user: UserModel)
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
        case .memorizationSession(let task, let surah):
            let presenter = MemorizationPresenter(task: task, surah: surah, navigation: navigationController)
            let vc = MemorizationViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            
            navigationController.pushViewController(vc, animated: true)
        case .targetDetail(let data, let user):
            let presenter = DetailTargetPresenter(navigation: navigationController, data: data, user: user)
            let vc = DetailTargetViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func switchToTab(_ tab: MainTabBarController.MainTab) {
        if let tabBar = navigationController.tabBarController as? MainTabBarController {
            tabBar.switchToTab(tab)
        }
    }
}
