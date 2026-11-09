//
//  DetailTargetPresenter.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit

protocol DetailTargetRouting: AnyObject {
    func openTask(task: TaskModel, surah: Quran.Surah.Response?)
}

final class DetailTargetPresenter {
    let navigation: UINavigationController
    var targetData: TargetModel?
    var surahData: Quran.Surah.Response?
    var userData: UserModel
    var newTask: TaskModel?
    
    weak var router: DetailTargetRouting?
    
    var onGetData: (() -> Void)?
    
    enum Routing {
        case ziyadahTask
        case murojaahTask
    }
    
    init(navigation: UINavigationController, user: UserModel) {
        self.navigation = navigation
        self.userData = user
    }
    
    func fetchData() {
        let group = DispatchGroup()
        var listSurah: [Quran.Surah.Response] = []
        var errorFlow: Bool = false
        
        group.enter()
        QuranRepository.fetchSurah { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                switch result {
                case .success(let response):
                    listSurah = response
                case .failure(let error):
                    errorFlow = true
                    print("Error: \(error)")
                }
                group.leave()
            }
        }
        
        group.enter()
        TargetRepository.getActiveTarget {[weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                switch result {
                case .success(let response):
                    self.targetData = response
                case .failure(let error):
                    errorFlow = true
                    print("Error: \(error)")
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard !errorFlow, let self, let targetData else {
                return
            }
            
            let targetSurahData = listSurah.first {
                $0.number == targetData.targetNumber
            }
            
            guard let targetSurahData else { return }
            
            surahData = targetSurahData
            self.onGetData?()
        }
    }
    
    func generateSections(totalVerseCount: Int, completedVerseCount: Int, tasks: [TaskModel]) -> [AyatSection] {
        var updateTasks = tasks
        var sections: [AyatSection] = []
        var startAyah = 1
        let nextAyah = completedVerseCount + 1
        
        let todayTask = updateTasks.first {
            guard let taskDate = $0.taskDate else {
                return false
            }
            
            return $0.type == .ziyadah && Calendar.current.isDateInToday(taskDate)
        }
        
        if todayTask == nil {
            let newTask = generateNewTask(updateTasks)
            updateTasks.append(newTask)
        }

        while startAyah <= totalVerseCount {
            let endAyah = min(startAyah + 9, totalVerseCount)
            
            let totalAyahInGroup = endAyah - startAyah + 1
            let completedInGroup = max(0, min(completedVerseCount, endAyah) - startAyah + 1)
            let todayAyahs = todayZiyadahAyahs(from: updateTasks)
            let todayCount = todayTaskCount(in: startAyah...endAyah, todayAyahs: todayAyahs)
            var subtitle = "\(completedInGroup)/\(totalAyahInGroup) dihafal"
            
            if todayCount > 0 {
                subtitle += " • \(todayCount) dalam tugas hari ini"
            }
            
            let isExpanded = (startAyah...endAyah).contains(nextAyah)
            
            let items = generateItems(
                startAyah: startAyah,
                endAyah: endAyah,
                completedVerseCount: completedVerseCount,
                todayAyah: todayAyahs,
                tasks: updateTasks
            )

            sections.append(
                AyatSection(
                    title: "Ayat \(startAyah) - \(endAyah)",
                    subtitle: subtitle,
                    isExpanded: isExpanded,
                    items: items
                )
            )

            startAyah = endAyah + 1
        }

        return sections
    }
    
    func generateItems(startAyah: Int, endAyah: Int, completedVerseCount: Int, todayAyah: Set<Int>, tasks: [TaskModel]) -> [AyatItem] {
        var items: [AyatItem] = []
        let nextAyah = completedVerseCount + 1
        
        for ayah in startAyah...endAyah {
            let status: AyatItem.Status

            if ayah <= completedVerseCount {
                status = .completed
            } else if ayah == nextAyah {
                status = .current
            } else {
                status = .upcoming
            }
            
            let repetitionCount = repetitionCount(for: ayah, tasks: tasks)
            let isToday = todayAyah.contains(ayah)

            items.append(
                AyatItem(
                    number: ayah,
                    status: status,
                    repetition: repetitionCount,
                    isToday: isToday
                )
            )
        }

        return items
    }
    
    func todayZiyadahAyahs(from tasks: [TaskModel]) -> Set<Int> {
        var ayahs = Set<Int>()
        let calendar = Calendar.current

        for task in tasks {
            guard task.type == .ziyadah, let taskDate = task.taskDate, calendar.isDateInToday(taskDate), let start = task.startAyah, let end = task.endAyah else {
                continue
            }

            for ayah in start...end {
                ayahs.insert(ayah)
            }
        }

        return ayahs
    }
    
    func todayTaskCount(in range: ClosedRange<Int>, todayAyahs: Set<Int>) -> Int {
        range.filter {
            todayAyahs.contains($0)
        }.count
    }
    
    func repetitionCount(for ayah: Int, tasks: [TaskModel]) -> Int {
        tasks.reduce(0) { count, task in
            guard task.type == .murojaah, let startAyah = task.startAyah, let endAyah = task.endAyah else { return count }
            return (startAyah...endAyah).contains(ayah) ? count + 1 : count
        }
    }

    func navigateTo(_ view: Routing) {
        switch view {
        case .ziyadahTask:
            let todayTask = targetData?.tasks?.first {
                guard let taskDate = $0.taskDate else { return false }
                return $0.type == .ziyadah && Calendar.current.isDateInToday(taskDate)
            }
            
            var selectedTask: TaskModel
            
            if let todayTask {
                selectedTask = todayTask
            } else if let newTask {
                selectedTask = newTask
            } else {
                guard let tasks = targetData?.tasks else { return }
                let newGeneratedTask = generateNewTask(tasks)
                selectedTask = newGeneratedTask
            }
            
            router?.openTask(task: selectedTask, surah: surahData)
        default:
            break
        }
    }
    
    private func generateNewTask(_ tasks: [TaskModel]) -> TaskModel {
        let lastTask = tasks.filter {
                $0.type == .ziyadah &&
                !Calendar.current.isDateInToday($0.taskDate ?? .distantPast)
            }
            .sorted {
                ($0.taskDate ?? .distantPast) >
                ($1.taskDate ?? .distantPast)
            }
            .first
        
        var newTask = TaskModel()
        newTask.status = .notStart
        newTask.completedEndAyah = 0
        newTask.type = .ziyadah
        newTask.taskDate = Date()
        
        newTask.surahNumber = surahData?.number
        var startAyah = 1
        
        if let lastTask, let taskStart = lastTask.startAyah, let completeAyah = lastTask.completedEndAyah  {
            startAyah = taskStart + completeAyah
            newTask.startAyah = startAyah
        } else {
            newTask.startAyah = startAyah
        }
        
        newTask.endAyah = min((startAyah + (userData.dailyVerseTarget - 1)), surahData?.numberOfAyahs ?? 0)
        
        self.newTask = newTask
        return newTask
    }
}
