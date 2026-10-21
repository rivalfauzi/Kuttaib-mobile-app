//
//  TasksData+CoreDataProperties.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import Foundation
import CoreData

extension TasksData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksData> {
        NSFetchRequest<TasksData>(entityName: "TasksData")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var status: String?
    @NSManaged public var surahNumber: Int16
    @NSManaged public var startAyah: Int16
    @NSManaged public var endAyah: Int16
    @NSManaged public var completedEndAyah: Int16
    @NSManaged public var type: String?
    @NSManaged public var taskDate: Date?
    @NSManaged public var target: TargetsData?
    
    func toModel() -> TaskModel {
        TaskModel(
            id: id,
            status: TaskStatus(rawValue: status ?? ""),
            surahNumber: Int(surahNumber),
            startAyah: Int(startAyah),
            endAyah: Int(endAyah),
            completedEndAyah: Int(completedEndAyah),
            type: TaskType(rawValue: type ?? ""),
            taskDate: taskDate
        )
    }
}
