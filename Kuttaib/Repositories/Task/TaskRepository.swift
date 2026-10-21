//
//  TaskRepository.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import Foundation
import CoreData

enum TaskRepository {
    static func fetchTask(callback: @escaping (Result<[TaskModel], Error>) -> Void ) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TasksData> = TasksData.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            let tasks = result.map {
                $0.toModel()
            }
            
            callback(.success(tasks))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func createTask(data: TaskModel, callback: @escaping (Result<TasksData, Error>) -> Void) {
        let context = CoreDataManager.shared.context
        
        let requestTarget: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
        requestTarget.predicate = NSPredicate(
            format: "status == %@",
            "active"
        )
        
        requestTarget.fetchLimit = 1

        do {
            if let activeTarget = try context.fetch(requestTarget).first {
                let task = TasksData(context: context)

                task.id = UUID()
                task.status = data.status?.rawValue
                task.surahNumber = Int16(data.surahNumber ?? -1)
                task.startAyah = Int16(data.startAyah ?? -1)
                task.endAyah = Int16(data.endAyah ?? -1)
                task.completedEndAyah = Int16(data.completedEndAyah ?? -1)
                task.type = data.type?.rawValue
                task.taskDate = data.taskDate
                task.target = activeTarget

                try context.save()

                callback(.success(task))
            } else {
                callback(.failure(RepositoryError.activeTargetNotFound))
            }
        } catch {
            callback(.failure(error))
        }
    }
}
