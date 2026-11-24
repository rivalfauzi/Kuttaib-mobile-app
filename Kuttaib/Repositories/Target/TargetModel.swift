//
//  TargetModel.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation

struct TargetModel {
    var id: UUID?
    var targetNumber: Int?
    var surahName: String?
    var targetType: TargetType?
    var totalVerseCount: Int?
    var completedVerseCount: Int?
    var status: TargetStatus?
    var createdAt: Date?
    var completedAt: Date?
    var tasks: [TaskModel]?
}

enum TargetStatus: String {
    case active
    case inActive
    case done
}

struct CreateTargetOnboardingRequest: Encodable {
    var targetType: String
    var targetNumber: Int
    var targetName: String
    var dailyTargetType: String
    var dailyTargetNumber: Double
    var dailyTime: Int
}

struct CreateTargetOnboardingResponse: Decodable {
    let id: String
    let target: String?
    let targetType: String?
    let totalTarget: Int?
    let targetDailyTime: Int?
    let estimation: Int?
}
