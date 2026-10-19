//
//  UserRepository.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation
import CoreData

//final class UserRepository {
//
//    private let context = CoreDataManager.shared.context
//
//    func fetchUser() -> User? {
//        let request: NSFetchRequest<User> = User.fetchRequest()
//
//        return try? context.fetch(request).first
//    }
//
//    func createUser(
//        name: String,
//        dailyVerseTarget: Int16,
//        dailyStudyTime: Int16
//    ) -> User {
//
//        let user = User(context: context)
//
//        user.id = UUID()
//        user.name = name
//        user.dailyVerseTarget = dailyVerseTarget
//        user.dailyStudyTime = dailyStudyTime
//
//        CoreDataManager.shared.save()
//
//        return user
//    }
//
//    func updatePreferences(
//        dailyVerseTarget: Int16,
//        dailyStudyTime: Int16
//    ) {
//        guard let user = fetchUser() else { return }
//
//        user.dailyVerseTarget = dailyVerseTarget
//        user.dailyStudyTime = dailyStudyTime
//
//        CoreDataManager.shared.save()
//    }
//}

enum UserRepository {
    static func saveUser(data: UserModel, callback: @escaping ((Result<Bool, Error>) -> Void)) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<UsersData> = UsersData.fetchRequest()
        request.fetchLimit = 1

        do {
            let user = try context.fetch(request).first ?? UsersData(context: context)
            
            user.name = data.name
            user.dailyVerseTarget = Int16(data.dailyVerseTarget)
            user.dailyStudyTime = Int16(data.dailyStudyTime)
            
            try context.save()
            
            callback(.success(true))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func fetchUser(callback: @escaping (Result<UserModel, Error>) -> Void ) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<UsersData> = UsersData.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request).first
            
            if let data = result?.toModel() {
                callback(.success(data))
            }
        } catch {
            callback(.failure(error))
        }
    }
}
