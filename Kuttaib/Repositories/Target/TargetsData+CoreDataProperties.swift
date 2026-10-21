//
//  TargetsData+CoreDataProperties.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

extension TargetsData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TargetsData> {
        NSFetchRequest<TargetsData>(entityName: "TargetsData")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var status: String?
    @NSManaged public var targetNumber: Int16
    @NSManaged public var targetType: String?
    @NSManaged public var totalVerseCount: Int16
    @NSManaged public var completedVerseCount: Int16
    @NSManaged public var completedAt: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var tasks: NSSet?
    
    func toModel() -> TargetModel {
        let taskModels = (tasks as? Set<TasksData>)?.map { $0.toModel() } ?? []
        
        return TargetModel(
            id: id,
            targetNumber: Int(targetNumber),
            targetType: TargetType(rawValue: targetType ?? ""),
            totalVerseCount: Int(totalVerseCount),
            completedVerseCount: Int(completedVerseCount),
            status: status,
            createdAt: createdAt,
            completedAt: completedAt,
            tasks: taskModels
        )
    }
}
