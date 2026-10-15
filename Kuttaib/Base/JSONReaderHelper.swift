//
//  JSONReaderHelper.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import Foundation

enum JSONReaderHelper {
    
    static func getJuzData(by number: Int, data: Quran.MetaData.Response) -> Quran.MetaData.Response.Juz.Reference? {
        let juzIndex = number - 1
        guard juzIndex < data.juzs.references.count
        else { return nil }
        
        return data.juzs.references[juzIndex]
    }
    
    static func getSurahData(by number: Int, data: [Quran.Surah.Response]) -> Quran.Surah.Response? {
        return data.first(where: {
            $0.number == number
        })
    }
    
    static func getSurahInJuz(in juz: Quran.MetaData.Response.Juz.Reference, surahs: [Quran.Surah.Response]) -> [Quran.Surah.Response] {
        return surahs.filter {
            $0.number >= juz.startAyah &&
            $0.number <= juz.endSurah
        }
    }
    
    static func totalAyahInJuz(in juz: Quran.MetaData.Response.Juz.Reference, surahs: [Quran.Surah.Response]) -> Int {
        var total = 0

        for surah in surahs {
            switch surah.number {
            case juz.startSurah ... juz.endSurah:
                if juz.startSurah == juz.endSurah {
                    total += juz.endAyah - juz.startAyah + 1
                } else if surah.number == juz.startSurah {
                    total += surah.numberOfAyahs - juz.startAyah + 1
                } else if surah.number == juz.endSurah {
                    total += juz.endAyah
                } else {
                    total += surah.numberOfAyahs
                }
            default:
                break
            }
        }

        return total
    }
    
//    static let shared = JSONReaderHelper()
//    var quranMetaDataCache: QuranMetaData?
//    var quranSurahDataCache: [QuranSurah]?
//    
//    // MARK: - QURAN META DATA
//    func quranMetaDataReader() -> QuranMetaData? {
//        guard let url = Bundle.main.url(forResource: "quranMetaData", withExtension: "json") else {
//            return nil
//        }
//        
//        if let quranMetaDataCache {
//            return quranMetaDataCache
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let metaData = try JSONDecoder().decode(QuranMetaData.self, from: data)
//            return metaData
//        } catch {
//            return nil
//        }
//    }
//    
//    func getJuz(by number: Int) -> QuranMetaData.Juz.Reference? {
//        let juzIndex = number - 1
//        guard let data = quranMetaDataReader()?.juzs.references, juzIndex < data.count else { return nil }
//        
//        return data[juzIndex]
//    }
//    
//    
//    // MARK: - QURAN SURAH
//    func quranSurahReader() -> [QuranSurah] {
//        guard let url = Bundle.main.url(forResource: "quranSurah", withExtension: "json") else {
//            return []
//        }
//        
//        if let quranSurahDataCache {
//            return quranSurahDataCache
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let surah = try JSONDecoder().decode([QuranSurah].self, from: data)
//            return surah
//        } catch {
//            return []
//        }
//    }
//    
//    func getSurah(by number: Int) -> QuranSurah? {
//        quranSurahReader().first { $0.number == number }
//    }
}
