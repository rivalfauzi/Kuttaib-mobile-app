//
//  HomeEntity.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import Foundation

struct HomeTaskSectionEntity {
    var title: String
    var status: TaskType
}

enum TaskType: String {
    case ziyadah
    case murojaah
    case rabt
}

enum TaskStatus: String {
    case notStart = "Not Start"
    case inProgress = "In Progress"
    case done = "Done"
}
