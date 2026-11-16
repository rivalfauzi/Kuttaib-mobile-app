//
//  TargetsCoordinator.swift
//  Kuttaib
//
//  Created by mco on 12/11/26.
//

import UIKit

final class TargetsCoordinator {
    let navigationController: UINavigationController
    
    enum Navigate {
        case memorizationSession(task: TaskModel, user: UserModel, surah: Quran.Surah.Response?)
        case murojaahSession(task: TaskModel, surah: Quran.Surah.Response?)
        case targetDetail(user: UserModel, target: TargetModel)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let presenter = TargetsPresenter(coordinator: self)
        let vc = TargetsViewController(presenter: presenter)

        navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigateTo(_ navigate: Navigate) {
        switch navigate {
        case .memorizationSession(let task, let user,  let surah):
            let presenter = MemorizationPresenter(task: task, userData: user,  surah: surah, navigation: navigationController)
            let vc = MemorizationViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            
            navigationController.pushViewController(vc, animated: true)
        case .targetDetail(let user, let target):
            let presenter = DetailTargetPresenter(user: user, targetData: target)
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
}

extension TargetsCoordinator: DetailTargetRouting {
    func openTask(task: TaskModel, user: UserModel, surah: Quran.Surah.Response?) {
        switch task.type {
        case .ziyadah:
            navigateTo(.memorizationSession(task: task, user: user, surah: surah))
        case .murojaah:
            navigateTo(.murojaahSession(task: task, surah: surah))
        default:
            break
        }
    }
}
