//
//  UsersData+CoreDataProperties.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

extension UsersData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersData> {
        NSFetchRequest<UsersData>(entityName: "UsersData")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var dailyVerseTarget: Int16
    @NSManaged public var dailyStudyTime: Int16
    
    func toModel() -> UserModel {
        UserModel(
            name: name ?? "",
            dailyVerseTarget: Int(dailyVerseTarget),
            dailyStudyTime: Int(dailyStudyTime)
        )
    }
}
