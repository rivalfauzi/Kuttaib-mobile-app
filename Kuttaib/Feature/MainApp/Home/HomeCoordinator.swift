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
        case targetDetail(user: UserModel)
        case murojaahSession(task: TaskModel, surah: Quran.Surah.Response?)
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
        case .targetDetail(let user):
            let presenter = DetailTargetPresenter(user: user)
            presenter.router = self
            
            let vc = DetailTargetViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        case .murojaahSession(let task, let surah):
            let presenter = MurojaahSessionPresenter(task: task, surah: surah)
            let vc = MurojaahSessionViewController(presenter: presenter)
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

extension HomeCoordinator: DetailTargetRouting {
    func openTask(task: TaskModel, surah: Quran.Surah.Response?) {
        switch task.type {
        case .ziyadah:
            navigateTo(.memorizationSession(task: task, surah: surah))
        case .murojaah:
            navigateTo(.murojaahSession(task: task, surah: surah))
        default:
            break
        }
    }
    
    
}
