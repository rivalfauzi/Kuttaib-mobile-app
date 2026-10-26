//
//  MemorizationPresenter.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import Foundation

final class MemorizationPresenter {
    let task: TaskModel
    let surah: Quran.Surah.Response?
    var ayahs: [Quran.Ayahs.Response] = []
    var viewState: ViewType = .learn
    
    enum ViewType {
        case learn
        case record
    }
    
    init(task: TaskModel, surah: Quran.Surah.Response?) {
        self.task = task
        self.surah = surah
    }
    
    func fetch(callback: @escaping (Result<[Quran.Ayahs.Response], Error>) -> Void) {
        QuranRepository.fetchAyah(callback: callback)
    }
    
    func getAyahsTask(_ data: [Quran.Ayahs.Response]) {
        guard let startAyah = task.startAyah, let endAyah = task.endAyah else { return }
        
        ayahs = data.filter {
            $0.surah.number == surah?.number &&
            $0.numberInSurah >= startAyah &&
            $0.numberInSurah <= endAyah
        }
    }
}
