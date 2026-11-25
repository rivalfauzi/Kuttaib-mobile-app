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
    
    static let mainTarget: [GeneralTargetEntity] = [
        .init(
            title: "An-Naba",
            subtitle: "Cocok untuk pemula",
            icon: "book.pages.fill",
            populer: true,
            value: 78,
            type: TargetType.surah.rawValue
        ),
        .init(
            title: "Juz 30",
            subtitle: "Paling sering dibaca",
            icon: "moon.stars.fill",
            populer: false,
            value: 30,
            type: TargetType.juz.rawValue
        ),
        .init(
            title: "Ar-Rahmaan",
            subtitle: "Favorit banyak penghafal",
            icon: "sparkles",
            populer: false,
            value: 55,
            type: TargetType.surah.rawValue
        ),
        .init(
            title: "Custom",
            subtitle: "Pilih surah atau juz",
            icon: "slider.horizontal.3",
            populer: false,
            value: 0
        )
    ]
    
    static let dailyVersesTarget: [GeneralTargetEntity] = [
        .init(
            title: "3 ayat",
            subtitle: "Santai dan konsisten",
            icon: "leaf.fill",
            populer: false,
            value: 3,
            type: SetTargetData.DailyTargetType.ayah.rawValue,
            iconTintColor: .primaryGold,
            background: .backgroundGold
        ),
        .init(
            title: "5 ayat",
            subtitle: "Seimbang dan efektif",
            icon: "tree.fill",
            populer: false,
            value: 5,
            type: SetTargetData.DailyTargetType.ayah.rawValue,
            iconTintColor: .primaryGreen,
            background: .backgroundGreen
        ),
        .init(
            title: "10 ayat",
            subtitle: "Untuk kamu yang lebih cepat",
            icon: "sparkles",
            populer: false,
            value: 10,
            type: SetTargetData.DailyTargetType.ayah.rawValue,
            iconTintColor: .primaryBlue,
            background: .backgroundBlue
        ),
        .init(
            title: "1/4 halaman",
            subtitle: "± 4 baris · Santai dan konsisten",
            icon: "leaf.fill",
            populer: false,
            value: 0.25,
            type: SetTargetData.DailyTargetType.page.rawValue,
            iconTintColor: .primaryGold,
            background: .backgroundGold
        ),
        .init(
            title: "1/2 halaman",
            subtitle: "± 8 baris · Seimbang dan efektif",
            icon: "tree.fill",
            populer: false,
            value: 0.5,
            type: SetTargetData.DailyTargetType.page.rawValue,
            iconTintColor: .primaryGreen,
            background: .backgroundGreen
        ),
        .init(
            title: "1 halaman",
            subtitle: "15 baris · Lebih cepat",
            icon: "sparkles",
            populer: false,
            value: 1,
            type: SetTargetData.DailyTargetType.page.rawValue,
            iconTintColor: .primaryBlue,
            background: .backgroundBlue
        )
    ]
    
    static let dailyTimeTarget: [GeneralTargetEntity] = [
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
