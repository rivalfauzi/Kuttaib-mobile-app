//
//  QuranRepository.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import Foundation

enum QuranRepository {
    
    static func fetchSurah(callback: @escaping (Result<[Quran.Surah.Response], Error>) -> Void) {
        do {
            let jsonResources = Bundle.main.url(
                forResource: "QuranSurahResponse",
                withExtension: "json"
            )!
            let responseBody = try Data(contentsOf: jsonResources)
            let decoded = try JSONDecoder().decode(
                [Quran.Surah.Response].self, from: responseBody
            )
            callback(.success(decoded))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func fetchMetaData(callback: @escaping (Result<Quran.MetaData.Response, Error>) -> Void) {
        do {
            let jsonResource = Bundle.main.url(
                forResource: "QuranMetaDataResponse",
                withExtension: "json"
            )!
            let responseBody = try Data(contentsOf: jsonResource)
            let decoded = try JSONDecoder().decode(Quran.MetaData.Response.self, from: responseBody)
            callback(.success(decoded))
        } catch {
            callback(.failure(error))
        }
    }
    
    static func fetchAyah(callback: @escaping (Result<[Quran.Ayahs.Response], Error>) -> Void) {
        do {
            let jsonResource = Bundle.main.url(
                forResource: "QuranPagesResponse",
                withExtension: "json"
            )!
            let responseBody = try Data(contentsOf: jsonResource)
            let decoded = try JSONDecoder().decode([Quran.Ayahs.Response].self, from: responseBody)
            callback(.success(decoded))
        } catch {
            callback(.failure(error))
        }
    }
}
