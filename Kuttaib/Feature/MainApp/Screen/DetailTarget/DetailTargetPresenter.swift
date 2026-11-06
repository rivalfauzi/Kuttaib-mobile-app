//
//  DetailTargetPresenter.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit

final class DetailTargetPresenter {
    let navigation: UINavigationController
    let targetData: TargetModel
    var surahData: Quran.Surah.Response?
    var userData: UserModel
    
    init(navigation: UINavigationController, data: TargetModel, user: UserModel) {
        self.navigation = navigation
        self.targetData = data
        self.userData = user
    }
    
    func fetchSurahData(callback: @escaping(Result<[Quran.Surah.Response], Error>) -> Void) {
        QuranRepository.fetchSurah(callback: callback)
    }
}
