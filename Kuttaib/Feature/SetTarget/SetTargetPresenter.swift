//
//  SetTargetPresenter.swift
//  Kuttaib
//
//  Created by mco on 13/10/26.
//

import Foundation

final class SetTargetPresenter {
    let store: SetTargetStore
    let coordinator: SetTargetCoordinator
    var mainTargetSelectedIndex: Int?
    
    let targetData: [SetTargetEntity] = [
        .init(
            title: "Apa Target Hafalanmu?",
            subtitle: "Pilih sesuai kemampuan dan tujuanmu. Tenang, ini bisa diubah nanti.",
            type: .main,
            items: [
                .init(
                    title: "Juz 30",
                    subtitle: "Cocok untuk pemula, berisi surah-surah pendek.",
                    icon: "book.pages.fill",
                    populer: true,
                    value: 30
                ),
                .init(
                    title: "1 Surah",
                    subtitle: "Mulai dari surah favoritmu",
                    icon: "bookmark.fill",
                    populer: false,
                    value: 1
                ),
                .init(
                    title: "Custom",
                    subtitle: "Pilih surah juz atau surah yang ingin dihafal",
                    icon: "slider.horizontal.3",
                    populer: false,
                    value: 0
                )
            ]
        ),
        .init(
            title: "Berapa target harianmu?",
            subtitle: "Pilih jumlah ayat atau halaman yang ingin kamu hafal setiap hari.",
            type: .daily,
            items: [
                .init(
                    title: "3 ayat",
                    subtitle: "Santai dan konsisten",
                    icon: "leaf.fill",
                    populer: false,
                    value: 3
                ),
                .init(
                    title: "5 ayat",
                    subtitle: "Seimbang dan efektif",
                    icon: "tree.fill",
                    populer: false,
                    value: 5
                ),
                .init(
                    title: "10 ayat",
                    subtitle: "Untuk kamu yang lebih cepat",
                    icon: "sparkles",
                    populer: false,
                    value: 10
                ),
                .init(
                    title: "1 halaman",
                    subtitle: "Cocok jika terbiasa menghafal per halaman",
                    icon: "book.pages.fill",
                    populer: false,
                    value: 1
                )
            ]
        ),
        .init(
            title: "Berapa waktu yang bisa kamu luangkan setiap hari?",
            subtitle: "Kami akan menyesuaikan tugas hafalan dengan waktu yang kamu piilh.",
            type: .time,
            items: [
                .init(
                    title: "10 menit",
                    subtitle: "Cukup untuk memulai",
                    icon: "clock.fill",
                    populer: false,
                    value: 10
                ),
                .init(
                    title: "15 menit",
                    subtitle: "Pilihan yang seimbang",
                    icon: "clock.fill",
                    populer: false,
                    value: 15
                ),
                .init(
                    title: "30 menit",
                    subtitle: "Untuk hasil lebih cepat",
                    icon: "clock.fill",
                    populer: false,
                    value: 30
                ),
                .init(
                    title: "1 jam",
                    subtitle: "Jika kamu ingin lebih maksimal",
                    icon: "clock.fill",
                    populer: false,
                    value: 60
                )
            ]
        )
    ]
    
    init(store: SetTargetStore, coordinator: SetTargetCoordinator) {
        self.store = store
        self.coordinator = coordinator
    }
    
    func navigate(_ type: SetTargetCoordinator.SetTargetButtonTapped) {
        coordinator.navigate(type)
    }
}
