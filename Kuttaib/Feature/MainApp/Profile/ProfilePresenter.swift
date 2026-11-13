//
//  ProfilePresenter.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import Foundation

final class ProfilePresenter {
    let coordinator: ProfileCoordinator
    var userData: UserModel?
    var activeTarget: TargetModel?
    var allUserTask: [TaskModel] = []
    var reminderData: ReminderSetting?
    var surah: [Quran.Surah.Response] = []
    
    var onFetchUserData: ((Result<UserModel, Error>) -> Void)?
    var onGetActiveTarget: ((Result<TargetModel?, Error>) -> Void)?
    var onGetAllTask: ((ProfileStatisticEntity) -> Void)?
    var onGetReminderData: ((ReminderSetting?) -> Void)?
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    func initialFetch() {
        fetchUser()
        getActiveTarget()
        fetchTask()
        getReminderData()
    }
    
    func fetchUser() {
        UserRepository.fetchUser { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.onFetchUserData?(result)
            }
        }
    }
    
    func getActiveTarget() {
        QuranRepository.fetchSurah {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                surah = response
                
                TargetRepository.getActiveTarget {[weak self] result in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.onGetActiveTarget?(result)
                    }
                }
                
            case .failure(let error):
                onGetActiveTarget?(.failure(error))
            }
        }
    }
    
    func fetchTask() {
        TaskRepository.fetchTask {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let ziyadahTasks = response.filter {
                    $0.type == .ziyadah
                }
                
                let totalAyah = ziyadahTasks.reduce(0) {
                    $0 + ($1.completedEndAyah ?? 0)
                }
                
                let totalDays = Set<Date>(
                    ziyadahTasks.compactMap {
                        guard let date = $0.taskDate else { return nil }
                        return Calendar.current.startOfDay(for: date)
                    }
                ).count
                
                let longestStreak = longestStreak(from: ziyadahTasks)
                
                let data = ProfileStatisticEntity(totalAyah: totalAyah, totalDays: totalDays, longestStreak: longestStreak)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.onGetAllTask?(data)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getReminderData() {
        self.reminderData = ReminderManager.shared.load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.onGetReminderData?(self?.reminderData)
        }
    }
    
    func fetchSurah(callback: @escaping (Result<[Quran.Surah.Response], Error>) -> Void) {
        QuranRepository.fetchSurah(callback: callback)
    }
    
    private func longestStreak(from tasks: [TaskModel]) -> Int {

        let calendar = Calendar.current

        let dates = tasks
            .compactMap { $0.taskDate }
            .map { calendar.startOfDay(for: $0) }
            .sorted()

        guard !dates.isEmpty else {
            return 0
        }

        var currentStreak = 1
        var longestStreak = 1

        for index in 1..<dates.count {

            let previous = dates[index - 1]
            let current = dates[index]

            let diff = calendar.dateComponents(
                [.day],
                from: previous,
                to: current
            ).day ?? 0

            if diff == 1 {

                currentStreak += 1
                longestStreak = max(
                    longestStreak,
                    currentStreak
                )

            } else if diff > 1 {

                currentStreak = 1
            }
        }

        return longestStreak
    }
    
    func saveUsername(_ name: String) {
        userData?.name = name
        
        guard let userData else { return }
        
        UserRepository.saveUser(data: userData) {[weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.onFetchUserData?(result)
            }
        }
    }
    
    func saveUserData() {
        guard let userData else { return }
        
        UserRepository.saveUser(data: userData) {[weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.onFetchUserData?(result)
            }
        }
    }
    
    func switchTarget(_ data: TargetModel, callback: @escaping (Result<TargetModel?, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            TargetRepository.switchTarget(data: data, callback: callback)
        }
    }
}
