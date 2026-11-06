//
//  DetailTarget.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import Foundation

struct AyatSection {
    let title: String
    let subtitle: String
    var isExpanded: Bool
    let items: [AyatItem]
}


struct AyatItem {
    
    let number: Int
    let title: String
    let subtitle: String
    let status: Status
    
    enum Status {
        case completed
        case today
        case upcoming
    }
}
