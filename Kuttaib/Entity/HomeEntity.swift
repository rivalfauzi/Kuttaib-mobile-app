//
//  HomeEntity.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import UIKit

struct HomeTaskSectionEntity {
    var title: String
    var status: TaskType
}

struct HomeStatisticsEntity {
    var title: String
    var description: String
    var icon: String
    var iconTintColor: UIColor
    var backgroundIcon: UIColor
}

struct WeeklyProgress {
    let day: String
    var count: Int
    var maxCount: Int
}

struct HomeRecomendationEntity {
    var icon: String
    var iconTintColor: UIColor
    var backgroundIcon: UIColor
    var title: String
    var description: String
    var buttonTitle: String
    var buttonKey: HomeRecomendationButtonKey
}

enum HomeRecomendationButtonKey {
    case reminder
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
