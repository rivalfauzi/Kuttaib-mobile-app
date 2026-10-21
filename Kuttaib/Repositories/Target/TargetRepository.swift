//
//  TargetRepository.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

enum TargetRepository {
    static func createTarget(data: TargetModel, callback: @escaping (Result<TargetsData, Error>) -> Void) {

        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()

        request.predicate = NSPredicate(
            format: "status == %@",
            "active"
        )

        do {
            let activeTarget = try context.fetch(request).first
            guard activeTarget == nil else {
                callback(.failure(RepositoryError.activeTargetExists))
                return
            }

            let target = TargetsData(context: context)

            target.id = UUID()
            target.targetType = data.targetType?.rawValue
            target.targetNumber = Int16(data.targetNumber ?? 0)

            target.totalVerseCount = Int16(data.totalVerseCount ?? 0)
            target.completedVerseCount = 0

            target.status = "active"
            target.createdAt = Date()

            try context.save()

            callback(.success(target))

        } catch {
            callback(.failure(error))
        }
    }
    
    static func getActiveTarget(callback: @escaping (Result<TargetModel?, Error>) -> Void) {
        let context = CoreDataManager.shared.context

        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()

        request.predicate = NSPredicate(
            format: "status == %@",
            "active"
        )

        request.fetchLimit = 1

        do {
            let activeTarget = try context.fetch(request).first
            
            if let data = activeTarget?.toModel() {
                callback(.success(data))
            }
        } catch {
            callback(.failure(error))
        }
    }
}
