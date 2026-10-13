//
//  OnboardingPresenter.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import Foundation

final class OnboardingPresenter {
    let coordinator: OnboardingCoordinator
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
    func nextButtonTapped() {
        coordinator.navigate()
    }
}
