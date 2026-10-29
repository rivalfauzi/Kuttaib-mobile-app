//
//  MemorizationPresenter.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class MemorizationPresenter {
    let navigation: UINavigationController
    var task: TaskModel
    let surah: Quran.Surah.Response?
    var ayahs: [Quran.Ayahs.Response] = []
    var allOfAyah: [Quran.Ayahs.Response] = []
    var viewState: ViewType = .learn
    
    enum ViewType {
        case learn
        case record
        case done
    }
    
    init(task: TaskModel, surah: Quran.Surah.Response?, navigation: UINavigationController) {
        self.task = task
        self.surah = surah
        self.navigation = navigation
    }
    
    func fetch(callback: @escaping (Result<[Quran.Ayahs.Response], Error>) -> Void) {
        QuranRepository.fetchAyah(callback: callback)
    }
    
    func getAyahsTask() {
        guard let startAyah = task.startAyah, let endAyah = task.endAyah, !allOfAyah.isEmpty else { return }
        
        ayahs = allOfAyah.filter {
            $0.surah.number == surah?.number &&
            $0.numberInSurah >= startAyah &&
            $0.numberInSurah <= endAyah
        }
    }
    
    func saveTaskUpdate(taskCompleted: Int, callback: @escaping (Result<TaskModel, Error>) -> Void) {
        var updateTask = task
        updateTask.completedEndAyah = max(taskCompleted, (updateTask.completedEndAyah ?? 0))
        
        if task.id != nil {
            TaskRepository.updateTask(data: updateTask, callback: callback)
        } else {
            task.status = .inProgress
            TaskRepository.createTask(data: updateTask, callback: callback)
        }
    }
    
    func addTaskTarget(callback: @escaping (Result<TaskModel, Error>) -> Void) {
        let endAyah = (task.endAyah ?? 0) + 1
        
        if let numberOfAyahs = surah?.numberOfAyahs, endAyah <= numberOfAyahs {
            task.endAyah = endAyah
            task.status = .inProgress
            TaskRepository.updateTask(data: task, callback: callback)
        } else {
            callback(.failure(RepositoryError.lastAyat))
        }
    }
    
    func finishTask(callback: @escaping (Result<TaskModel, Error>) -> Void) {
        task.status = .done
        TaskRepository.updateTask(data: task, callback: callback)
    }
    
    func navigateToRootView() {
        navigation.popToRootViewController(animated: true)
    }
    
    func popView() {
        navigation.popViewController(animated: true)
    }
}
