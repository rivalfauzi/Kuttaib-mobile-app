//
//  HomePresenter.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation

final class HomePresenter {
    let coordinator: HomeCoordinator
    var userData: UserModel?
    var targetData: TargetModel?
    var surahData: [Quran.Surah.Response]?
    
    var onFetchUserData: ((Result<UserModel, Error>) -> Void)?
    var onFetchTargetData: ((TargetModel?) -> Void)?
    var onFetchTaskData: (([TaskModel]) -> Void)?
    var onFetchAllTaskData: (([TaskModel]) -> Void)?
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    func initialService() {
        let group = DispatchGroup()
        
        group.enter()
        UserRepository.fetchUser { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.onFetchUserData?(result)
                group.leave()
            }
        }
        
        var juzData: [Quran.MetaData.Response.Juz.Reference] = []
        var allTaskData: [TaskModel] = []
        var errorFlow: Bool = false
        
        group.enter()
        TargetRepository.getActiveTarget { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                self?.targetData = response
            case .failure(let error):
                print("Error: \(error)")
                errorFlow = true
            }
        }
        
        group.enter()
        QuranRepository.fetchSurah {[weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                self?.surahData = response
            case .failure(let error):
                print(error)
                errorFlow = true
            }
        }
        
        group.enter()
        QuranRepository.fetchMetaData { result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                juzData = response.juzs.references
            case .failure(let error):
                print(error)
                errorFlow = true
            }
        }
        
        group.enter()
        TaskRepository.fetchTask { result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                allTaskData = response
            case .failure(let error):
                print("Error: \(error)")
                errorFlow = true
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard !errorFlow, let self else {
                return
            }
            
            let lastTask = targetData?.tasks?
                .filter {
                    $0.type == .ziyadah &&
                    !Calendar.current.isDateInToday($0.taskDate ?? .distantPast)
                }
                .sorted {
                    ($0.taskDate ?? .distantPast) >
                    ($1.taskDate ?? .distantPast)
                }
                .first
            
            var todayTask = targetData?.tasks?.filter {
                $0.taskDate.map {
                    Calendar.current.isDateInToday($0)
                } ?? false &&
                $0.shouldDisplayOnDashboard ?? true
            } ?? []
            
            if todayTask.isEmpty {
                [TaskType.ziyadah, TaskType.murojaah].forEach { type in
                    if case .ziyadah = type {
                        guard let task = self.setZiyadahTask(
                            lastTask: lastTask,
                            juzsData: juzData
                        ) else { return }
                        
                        todayTask.append(task)
                    } else if case .murojaah = type {
                        guard let surahNo = lastTask?.surahNumber, let start = lastTask?.startAyah, let completed = lastTask?.completedEndAyah else { return }
                        
                        let task = TaskModel(
                            id: nil,
                            status: .notStart,
                            surahNumber: surahNo,
                            startAyah: start,
                            endAyah: start + completed - 1,
                            completedEndAyah: 0,
                            type: type,
                            taskDate: Date()
                        )
                        
                        todayTask.append(task)
                    }
                }
            } else if todayTask.count == 1 {
                if todayTask[0].type == .murojaah {
                    guard let task = self.setZiyadahTask(
                        lastTask: lastTask,
                        juzsData: juzData
                    ) else { return }
                    
                    todayTask.insert(task, at: 0)
                } else {
                    if let lastTask {
                        guard let start = lastTask.startAyah, let completed = lastTask.completedEndAyah else { return }
                        
                        let task = TaskModel(
                            status: .notStart,
                            surahNumber: lastTask.surahNumber,
                            startAyah: start,
                            endAyah: start + completed - 1,
                            completedEndAyah: 0,
                            type: .murojaah,
                            taskDate: Date()
                        )
                        
                        todayTask.append(task)
                    }
                }
            } else {
                todayTask = todayTask.sorted { lhs, rhs in
                    lhs.type == .ziyadah &&
                    rhs.type != .ziyadah
                }
            }
            
            onFetchTargetData?(targetData)
            onFetchAllTaskData?(allTaskData)
            onFetchTaskData?(todayTask)
        }
    }
    
    private func setZiyadahTask(lastTask: TaskModel?, juzsData: [Quran.MetaData.Response.Juz.Reference]?) -> TaskModel? {
        guard let userData, let targetData, let surahData, let targetType = targetData.targetType, let targetNumber = targetData.targetNumber else { return nil }
        
        var newTask = TaskModel()
        newTask.status = .notStart
        newTask.completedEndAyah = 0
        newTask.type = .ziyadah
        newTask.taskDate = Date()
        
        let dailyVerseTarget = userData.dailyVerseTarget - 1
        
        switch targetType {
        case .juz:
            guard let juzData = juzsData?[targetNumber - 1] else { return nil }
            
            if let lastTask {
                guard let surahNumber = lastTask.surahNumber, let taskStart = lastTask.startAyah, let completedEndAyah = lastTask.completedEndAyah else { return nil }
                
                var taskSurahData = surahData.first {
                    $0.number == surahNumber
                }
                
                var startAyah = taskStart + completedEndAyah + 1
                var endAyah: Int
                
                if surahNumber == juzData.endSurah {
                    endAyah = min((startAyah + dailyVerseTarget), juzData.endSurah)
                } else {
                    if startAyah > taskSurahData?.numberOfAyahs ?? 0 {
                        startAyah = 1
                        taskSurahData = surahData.first {
                            $0.number == (surahNumber + 1)
                        }
                    }
                    
                    endAyah = min((startAyah + dailyVerseTarget), taskSurahData?.numberOfAyahs ?? 0)
                }
                
                newTask.startAyah = startAyah
                newTask.endAyah = endAyah
                newTask.surahNumber = taskSurahData?.number
            } else {
                let startAyah = juzData.startAyah
                let endAyah = startAyah + dailyVerseTarget
                
                newTask.surahNumber = juzData.startSurah
                newTask.startAyah = startAyah
                newTask.endAyah = endAyah
            }
            
        case .surah:
            let surahData = surahData.first {
                $0.number == targetNumber
            }
            
            newTask.surahNumber = surahData?.number
            var startAyah = 1
            
            if let lastTask, let taskStart = lastTask.startAyah, let completeAyah = lastTask.completedEndAyah  {
                startAyah = taskStart + completeAyah
                newTask.startAyah = startAyah
            } else {
                newTask.startAyah = startAyah
            }
            
            newTask.endAyah = min((startAyah + dailyVerseTarget), surahData?.numberOfAyahs ?? 0)
        }
        
        return newTask
    }
    
    func navigateTo(_ navigate: HomeCoordinator.Navigate) {
        coordinator.navigateTo(navigate)
    }
    
    func switchTabBar(_ tab: MainTabBarController.MainTab) {
        coordinator.switchToTab(tab)
    }
    
    func createNewTarget(surahData: Quran.Surah.Response, callback: @escaping () -> Void) {
        var targetModel = TargetModel()
        targetModel.targetType = .surah
        targetModel.targetNumber = surahData.number
        targetModel.totalVerseCount = surahData.numberOfAyahs
        
        TargetRepository.createTarget(data: targetModel) { _ in
            callback()
        }
    }
}
