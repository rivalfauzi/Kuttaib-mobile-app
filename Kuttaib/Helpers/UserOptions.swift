//
//  UserOptions.swift
//  Kuttaib
//
//  Created by mco on 05/11/26.
//

import Foundation

enum UserOptions {

    enum Target {
        static let dailyVerses = [
            1, 3, 5, 10, 15, 20
        ]
    }

    enum Study {
        static let dailyMinutes = [
            5, 10, 15, 20, 30, 45, 60
        ]
    }

    enum Reminder {
        static let hours = Array(0...23)
        static let minutes = Array(0...59)
    }
    
    static let dailyVersesTarget: [MainTargetEntity] = [
        .init(
            title: "3 ayat",
            subtitle: "Santai dan konsisten",
            icon: "leaf.fill",
            populer: false,
            value: 3,
            type: SetTargetData.DailyTargetType.ayat.rawValue,
            iconTintColor: .primaryGold,
            background: .backgroundGold
        ),
        .init(
            title: "5 ayat",
            subtitle: "Seimbang dan efektif",
            icon: "tree.fill",
            populer: false,
            value: 5,
            type: SetTargetData.DailyTargetType.ayat.rawValue,
            iconTintColor: .primaryGreen,
            background: .backgroundGreen
        ),
        .init(
            title: "10 ayat",
            subtitle: "Untuk kamu yang lebih cepat",
            icon: "sparkles",
            populer: false,
            value: 10,
            type: SetTargetData.DailyTargetType.ayat.rawValue,
            iconTintColor: .primaryBlue,
            background: .backgroundBlue
        )
    ]
    
    static let dailyTimeTarget: [MainTargetEntity] = [
        .init(
            title: "10 menit",
            subtitle: "Cukup untuk memulai",
            icon: "clock.fill",
            populer: false,
            value: 10,
            iconTintColor: .primaryGreen,
            background: .backgroundGreen
        ),
        .init(
            title: "15 menit",
            subtitle: "Pilihan yang seimbang",
            icon: "clock",
            populer: false,
            value: 15,
            iconTintColor: .primaryBlue,
            background: .backgroundBlue
        ),
        .init(
            title: "30 menit",
            subtitle: "Untuk hasil lebih cepat",
            icon: "clock.arrow.circlepath",
            populer: false,
            value: 30,
            iconTintColor: .primaryGold,
            background: .backgroundGold
        ),
        .init(
            title: "60 menit",
            subtitle: "Jika kamu ingin lebih maksimal",
            icon: "timer",
            populer: false,
            value: 60,
            iconTintColor: .primaryRed,
            background: .backgroundRed
        )
    ]
}
