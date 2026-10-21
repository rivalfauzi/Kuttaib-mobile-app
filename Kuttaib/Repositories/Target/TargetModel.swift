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
    var targetType: TargetType?
    var totalVerseCount: Int?
    var completedVerseCount: Int?
    var status: String?
    var createdAt: Date?
    var completedAt: Date?
    var tasks: [TaskModel]?
}
