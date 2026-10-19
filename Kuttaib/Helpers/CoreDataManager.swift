//
//  CoreDataManager.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Kuttaib")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()

    func save() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
