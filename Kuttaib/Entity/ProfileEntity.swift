//
//  ProfileEntity.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit

enum Weekday: Int, CaseIterable, Codable {
    case min = 1
    case sen = 2
    case sel = 3
    case rab = 4
    case kam = 5
    case jum = 6
    case sab = 7
    
    var title: String {
        switch self {
        case .sen: "Sen"
        case .sel: "Sel"
        case .rab: "Rab"
        case .kam: "Kam"
        case .jum: "Jum"
        case .sab: "Sab"
        case .min: "Min"
        }
    }
}

struct ProfileStatisticEntity {
    let totalAyah: Int
    let totalDays: Int
    let longestStreak: Int

}
