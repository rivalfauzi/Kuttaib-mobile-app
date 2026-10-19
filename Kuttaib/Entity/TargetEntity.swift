//
//  TargetEntity.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import Foundation

struct MainTargetEntity {
    let title: String
    let subtitle: String
    let icon: String
    let populer: Bool
    let value: Int
    var type: String?
}

struct SetTargetEntity {
    let title: String
    let subtitle: String
    let type: SetTargetViewType
    var items: [MainTargetEntity]
}

enum SetTargetViewType {
    case main
    case daily
    case time
}

struct SetTargetData {
    var mainTarget: MainTargetData?
    var dailyTarget: DailyTargetData?
    var timeTarget: Int?
    
    
    struct MainTargetData {
        var value: Int
        var name: String?
        var type: TargetSelectionTab
    }
    
    enum TargetSelectionTab: String {
        case juz
        case surah
    }
    
    struct DailyTargetData {
        let value: Int
        let type: DailyTargetType
    }
    
    enum DailyTargetType: String {
        case ayat
        case page
    }
}
