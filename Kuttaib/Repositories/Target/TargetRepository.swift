//
//  TargetRepository.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

enum TargetRepository {
    static func createTarget(data: TargetModel, callback: @escaping (Result<TargetModel, Error>) -> Void) {

        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()

        request.predicate = NSPredicate(
            format: "status == %@",
            TargetStatus.active.rawValue
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
            target.surahName = data.surahName

            target.totalVerseCount = Int16(data.totalVerseCount ?? 0)
            target.completedVerseCount = 0

            target.status = TargetStatus.active.rawValue
            target.createdAt = Date()

            try context.save()

            callback(.success(target.toModel()))

        } catch {
            callback(.failure(error))
        }
    }
    
    static func getActiveTarget(callback: @escaping (Result<TargetModel?, Error>) -> Void) {
        let context = CoreDataManager.shared.context

        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()

        request.predicate = NSPredicate(
            format: "status == %@",
            TargetStatus.active.rawValue
        )

        request.fetchLimit = 1

        do {
            let activeTarget = try context.fetch(request).first
            callback(.success(activeTarget?.toModel()))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func switchTarget(data: TargetModel, callback: @escaping (Result<TargetModel?, Error>) -> Void) {
        let context = CoreDataManager.shared.context

        do {
            let activeRequest: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
            activeRequest.predicate = NSPredicate(
                format: "status == %@",
                TargetStatus.active.rawValue
            )
            activeRequest.fetchLimit = 1

            try context.fetch(activeRequest)
                .first?
                .setValue(TargetStatus.inActive.rawValue, forKey: "status")

            var target: TargetsData?

            if let id = data.id {
                let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
                request.predicate = NSPredicate(
                    format: "id == %@",
                    id.uuidString
                )
                request.fetchLimit = 1

                target = try context.fetch(request).first
            }

            if target == nil {
                target = TargetsData(context: context)

                target?.id = data.id ?? UUID()
                target?.targetType = data.targetType?.rawValue
                target?.targetNumber = Int16(data.targetNumber ?? 0)
                target?.surahName = data.surahName
                target?.totalVerseCount = Int16(data.totalVerseCount ?? 0)
                target?.createdAt = data.createdAt ?? Date()
            }

            target?.completedVerseCount = Int16(data.completedVerseCount ?? 0)
            target?.completedAt = data.completedAt
            target?.status = TargetStatus.active.rawValue

            try context.save()

            callback(.success(target?.toModel()))

        } catch {
            callback(.failure(error))
        }
    }
    
    static func doneTarget(callback: @escaping(Result<TargetModel?, Error>) -> Void) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "status == %@",
            TargetStatus.active.rawValue
        )
        
        request.fetchLimit = 1
        
        do {
            let target = try context.fetch(request).first
            target?.status = TargetStatus.done.rawValue
            target?.completedAt = Date()
            try context.save()
            callback(.success(target?.toModel()))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func getAllTarget(callback: @escaping(Result<[TargetModel], Error>) -> Void) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            let targets = result.map {
                $0.toModel()
            }
            
            callback(.success(targets))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func getTargetByNumber(number: Int, callback: @escaping(Result<TargetModel?, Error>) -> Void) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<TargetsData> = TargetsData.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "targetNumber == %d",
            number
        )
        
        request.fetchLimit = 1
        
        do {
            let target = try context.fetch(request).first
            
            callback(.success(target?.toModel()))
        } catch {
            callback(.failure(error))
        }
    }
    
//    static func createTargetV2(param: CreateTargetOnboardingRequest) -> URLSessionDataTask {
//        
//    }
}
