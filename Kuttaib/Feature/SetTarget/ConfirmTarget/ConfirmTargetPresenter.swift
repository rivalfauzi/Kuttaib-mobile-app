//
//  ConfirmTargetPresenter.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation

final class ConfirmTargetPresenter {
    let coordinator: SetTargetCoordinator
    let data: [MainTargetEntity]
    
    init(coordinator: SetTargetCoordinator, data: [MainTargetEntity]) {
        self.coordinator = coordinator
        self.data = data
    }
    
    func onNextButtonTapped() {
        coordinator.navigate(.home)
    }
}
