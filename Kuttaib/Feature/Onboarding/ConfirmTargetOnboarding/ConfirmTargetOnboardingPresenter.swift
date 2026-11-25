//
//  ConfirmTargetOnboardingPresenter.swift
//  Kuttaib
//
//  Created by mco on 25/11/26.
//

import Foundation

final class ConfirmTargetOnboardingPresenter {
    let coordinator: OnboardingCoordinator
    let data: CreateTargetOnboardingResponse
    
    init(coordinator: OnboardingCoordinator, data: CreateTargetOnboardingResponse) {
        self.coordinator = coordinator
        self.data = data
    }
    
    func onNextButtonTapped() {
        coordinator.navigate(.home)
    }
}
