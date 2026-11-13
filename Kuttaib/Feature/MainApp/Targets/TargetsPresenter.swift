//
//  TargetsPresenter.swift
//  Kuttaib
//
//  Created by mco on 12/11/26.
//

import Foundation

final class TargetsPresenter {
    let coordinator: TargetsCoordinator
    var activeTarget: TargetModel?
    var inActiveTargets: [TargetModel] = []
    var doneTargets: [TargetModel] = []
    var surah: [Quran.Surah.Response] = []
    var userData: UserModel?
    
    init(coordinator: TargetsCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchTarget(callback: @escaping(Result<[TargetModel], Error>) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        UserRepository.fetchUser {[weak self] result in
            defer { group.leave() }
            
            switch result {
            case .success(let response):
                self?.userData = response
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        group.enter()
        QuranRepository.fetchSurah {[weak self] result in
            defer { group.leave() }
            
            switch result {
            case .success(let response):
                self?.surah = response
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        group.notify(queue: .main) {
            TargetRepository.getAllTarget(callback: callback)
        }
    }
    
    func navigateTo(_ navigate: TargetsCoordinator.Navigate) {
        coordinator.navigateTo(navigate)
    }
}
