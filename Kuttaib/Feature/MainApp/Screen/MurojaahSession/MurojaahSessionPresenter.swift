//
//  MurojaahSessionPresenter.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit

final class MurojaahSessionPresenter {
    var task: TaskModel
    let surah: Quran.Surah.Response?
    var target: TargetModel?
    var ayahs: [Quran.Ayahs.Response] = []
    
    var onGetActiveTarget: ((Result<TargetModel?, Error>) -> Void)?
    var onGetAyah: ((Result<[Quran.Ayahs.Response], Error>) -> Void)?
    var onDone: (() -> Void)?
    
    init(task: TaskModel, surah: Quran.Surah.Response?) {
        self.task = task
        self.surah = surah
    }
    
    func initService() {
        let group = DispatchGroup()
        
        group.enter()
        TargetRepository.getActiveTarget {[weak self] result in
            self?.onGetActiveTarget?(result)
            group.leave()
        }
        
        group.enter()
        QuranRepository.fetchAyah {[weak self] result in
            self?.onGetAyah?(result)
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.onDone?()
        }
    }
    
    func repetitionCount(for ayah: Int, tasks: [TaskModel]) -> Int {
        tasks.reduce(0) { count, task in
            guard task.type == .murojaah, let startAyah = task.startAyah, let endAyah = task.endAyah else { return count }
            return (startAyah...endAyah).contains(ayah) ? count + 1 : count
        }
    }
    
    func saveMurojaahTask(callback: @escaping(Result<TaskModel, Error>) -> Void) {
        guard let completedEndAyah = task.completedEndAyah else { return }
        
        task.completedEndAyah = completedEndAyah + 1
        
        if task.id != nil {
            TaskRepository.updateTask(data: task, callback: callback)
        } else {
            TaskRepository.createTask(data: task, callback: callback)
        }
    }
}
