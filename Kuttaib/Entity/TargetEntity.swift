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
}

struct SetTargetEntity {
    let title: String
    let subtitle: String
    let type: SetTargetViewType
    let items: [MainTargetEntity]
}

enum SetTargetViewType {
    case main
    case daily
    case time
}
