//
//  TargetEntity.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

struct GeneralTargetEntity {
    let title: String
    let subtitle: String
    let icon: String
    let populer: Bool
    let value: Double
    var type: String?
    var iconTintColor: UIColor?
    var background: UIColor?
}

struct SetTargetEntity {
    let title: String
    let subtitle: String
    let type: SetTargetViewType
    var items: [GeneralTargetEntity]
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
        var value: Double
        var type: TargetType
    }
    
    struct DailyTargetData {
        let value: Double
        let type: DailyTargetType
    }
    
    enum DailyTargetType: String {
        case ayah = "AYAH"
        case page = "PAGE"
    }
}

enum TargetType: String {
    case juz = "JUZ"
    case surah = "SURAH"
}
