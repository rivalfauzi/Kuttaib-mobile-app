//
//  SetTargetOnboardingPresenter.swift
//  Kuttaib
//
//  Created by mco on 23/11/26.
//

import Foundation

final class SetTargetOnboardingPresenter {
    let coordinator: OnboardingCoordinator
    var targetDataStore: SetTargetData = SetTargetData()
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
    func createTargetOnboarding(callback: @escaping(Result<CreateTargetOnboardingResponse, Error>) -> Void) -> URLSessionDataTask? {
        guard let userId = KeychainHelper.shared.get(.userId),
              let targetType = targetDataStore.mainTarget?.type.rawValue,
              let targetNumber = targetDataStore.mainTarget?.value,
              let dailyTargetType = targetDataStore.dailyTarget?.type.rawValue,
              let dailyTargetNumber = targetDataStore.dailyTarget?.value,
              let dailyTime = targetDataStore.timeTarget
        else { return nil }
        
        let param = CreateTargetOnboardingRequest(
            userId: userId,
            dailyTarget: dailyTargetNumber,
            dailyTargetType: dailyTargetType,
            targetNumber: Int(targetNumber),
            targetType: targetType,
            targetTime: dailyTime
        )
        
        return ApiRequest.request(Endpoint.Target.CreateOnboardingTarget.url, parameters: param) { result in
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
    func navigateTo(_ to: OnboardingCoordinator.Navigation) {
        coordinator.navigate(to)
    }
}
    
