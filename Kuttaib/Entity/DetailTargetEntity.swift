//
//  DetailTarget.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import Foundation

enum AyatListItem {
    case header(AyatSection)
    case ayat(AyatItem)
}

struct AyatSection {
    let id = UUID()
    let title: String
    let subtitle: String
    var isExpanded: Bool
    let items: [AyatItem]
}

struct AyatItem {
    let number: Int
    let status: Status
    var repetition: Int?
    var isToday: Bool?
    
    enum Status {
        case completed
        case current
        case upcoming
    }
}
