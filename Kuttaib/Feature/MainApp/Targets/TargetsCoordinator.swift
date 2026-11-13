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
        case targetDetail(user: UserModel)
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
        case .targetDetail(let user):
            let presenter = DetailTargetPresenter(user: user)
            presenter.router = self
            
            let vc = DetailTargetViewController(presenter: presenter)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension TargetsCoordinator: DetailTargetRouting {
    func openTask(task: TaskModel, user: UserModel, surah: Quran.Surah.Response?) {
        switch task.type {
        case .ziyadah:
            break
        case .murojaah:
            break
        default:
            break
        }
    }
}
