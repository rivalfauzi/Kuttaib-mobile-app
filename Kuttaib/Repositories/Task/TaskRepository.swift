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
    
    static func createTask(data: TaskModel, callback: @escaping (Result<TaskModel, Error>) -> Void) {
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

                callback(.success(task.toModel()))
            } else {
                callback(.failure(RepositoryError.activeTargetNotFound))
            }
        } catch {
            callback(.failure(error))
        }
    }
    
    static func updateTask(data: TaskModel, callback: @escaping (Result<TaskModel, Error>) -> Void) {
        guard let id = data.id else {
            callback(.failure(RepositoryError.dataNotFound))
            return
        }
        
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TasksData> = TasksData.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        request.fetchLimit = 1
        
        do {
            if let task = try context.fetch(request).first {
                if let completedEndAyah = data.completedEndAyah {
                    task.completedEndAyah = Int16(completedEndAyah)
                }
                
                if let status = data.status {
                    task.status = status.rawValue
                }
                
                if let endAyah = data.endAyah {
                    task.endAyah = Int16(endAyah)
                }
                
                try context.save()
            } else {
                callback(.failure(RepositoryError.dataNotFound))
            }
            
        } catch {
            callback(.failure(error))
        }
    }
}
