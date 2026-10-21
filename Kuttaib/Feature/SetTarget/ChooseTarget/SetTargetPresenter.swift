//
//  SetTargetPresenter.swift
//  Kuttaib
//
//  Created by mco on 13/10/26.
//

import Foundation

final class SetTargetPresenter {
    let coordinator: SetTargetCoordinator
    var targetDataStore: SetTargetData = SetTargetData()
    var surahData: [Quran.Surah.Response]?
    var selectedDataIndexes: [Int: Int] = [:]
    var targetModel = TargetModel()
    
    var targetData: [SetTargetEntity] = [
        .init(
            title: "Apa Target Hafalanmu?",
            subtitle: "Pilih sesuai kemampuan dan tujuanmu. Tenang, ini bisa diubah nanti.",
            type: .main,
            items: [
                .init(
                    title: "Juz 30",
                    subtitle: "Cocok untuk pemula",
                    icon: "book.pages.fill",
                    populer: true,
                    value: 30,
                    type: TargetType.juz.rawValue
                ),
                .init(
                    title: "Al-Mulk",
                    subtitle: "Surah pendek populer",
                    icon: "moon.stars.fill",
                    populer: false,
                    value: 67,
                    type: TargetType.surah.rawValue
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
                    value: 3,
                    type: SetTargetData.DailyTargetType.ayat.rawValue
                ),
                .init(
                    title: "5 ayat",
                    subtitle: "Seimbang dan efektif",
                    icon: "tree.fill",
                    populer: false,
                    value: 5,
                    type: SetTargetData.DailyTargetType.ayat.rawValue
                ),
                .init(
                    title: "10 ayat",
                    subtitle: "Untuk kamu yang lebih cepat",
                    icon: "sparkles",
                    populer: false,
                    value: 10,
                    type: SetTargetData.DailyTargetType.ayat.rawValue
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
                    title: "60 menit",
                    subtitle: "Jika kamu ingin lebih maksimal",
                    icon: "clock.fill",
                    populer: false,
                    value: 60
                )
            ]
        )
    ]
    
    init(coordinator: SetTargetCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigate(_ type: SetTargetCoordinator.SetTargetButtonTapped) {
        coordinator.navigate(type)
    }
    
    func fetch(callback: @escaping (Result<[Quran.Surah.Response], Error>) -> Void) {
        QuranRepository.fetchSurah(callback: callback)
    }
    
    func fetchQuranMetaData(callback: @escaping (Result<Quran.MetaData.Response, Error>) -> Void) {
        QuranRepository.fetchMetaData(callback: callback)
    }
    
    func saveData(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let dailyTarget = targetDataStore.dailyTarget?.value,
              let timeTarget = targetDataStore.timeTarget else {
            let error = NSError(domain: "Data Tidak Ditemukan", code: -1)
            callback(.failure(error))
            return
        }
        
        let group = DispatchGroup()
        var saveError: Error?
        
        group.enter()
        let user = UserModel(name: "Penghafal", dailyVerseTarget: dailyTarget, dailyStudyTime: timeTarget)
        
        UserRepository.saveUser(data: user) { result in
            if case .failure(let error) = result {
                saveError = error
            }
            group.leave()
        }
        
        group.enter()
        TargetRepository.createTarget(data: targetModel) { result in
            if case .failure(let error) = result {
                saveError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = saveError {
                callback(.failure(error))
            } else {
                callback(.success(true))
            }
        }
    }
    
    func calculateTarget(_ metaData: Quran.MetaData.Response, callback: @escaping ([MainTargetEntity]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self, let dailyTarget = targetDataStore.dailyTarget,
                let mainTarget = targetDataStore.mainTarget,
                let timeTarget = targetDataStore.timeTarget,
                let surahData
            else { return }
            
            var totalAyat: Int
            var daysEstimate: Int
            
            switch mainTarget.type {
            case .juz:
                guard let juzData = JSONReaderHelper.getJuzData(by: mainTarget.value, data: metaData) else { return }
                
                let arrayOfSurahs = JSONReaderHelper.getSurahInJuz(in: juzData, surahs: surahData)
                
                totalAyat = JSONReaderHelper.totalAyahInJuz(in: juzData, surahs: arrayOfSurahs)
            case .surah:
                guard let surah = JSONReaderHelper.getSurahData(by: mainTarget.value, data: surahData) else { return }
                
                totalAyat = surah.numberOfAyahs
            }
            
            targetModel.targetType = mainTarget.type
            targetModel.targetNumber = mainTarget.value
            targetModel.totalVerseCount = totalAyat

            switch dailyTarget.type {
            case .ayat:
                daysEstimate = Int(ceil(Double(totalAyat) / Double(dailyTarget.value)))
            case .page:
                daysEstimate = 0
            }
            
            let mainTargetLabel: String
            
            if case .surah = mainTarget.type, let name = mainTarget.name {
                mainTargetLabel = "\(mainTarget.type.rawValue.capitalized) \(name)"
            } else {
                mainTargetLabel = "\(mainTarget.type.rawValue.capitalized) \(mainTarget.value)"
            }
            
            let items: [MainTargetEntity] = [
                .init(title: "Target", subtitle: mainTargetLabel, icon: "book.pages.fill", populer: false, value: 0),
                .init(title: "Target Harian", subtitle: "\(dailyTarget.value) ayat per hari", icon: "tree.fill", populer: false, value: 0),
                .init(title: "Waktu Belajar", subtitle: "\(timeTarget) menit per hari", icon: "clock.fill", populer: false, value: 0),
                .init(title: "Estimasi Selesai", subtitle: "\(daysEstimate) hari", icon: "clock.fill", populer: false, value: 0)
            ]
            
            callback(items)
        }
    }
}
