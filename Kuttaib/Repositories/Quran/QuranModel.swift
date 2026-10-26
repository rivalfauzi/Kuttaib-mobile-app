//
//  QuranEntity.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import Foundation

enum Quran {
    
    enum Surah {
        
        struct Response: Decodable {
            let number: Int
            let name: String
            let englishName: String
            let englishNameTranslation: String
            let numberOfAyahs: Int
            let revelationType: String
        }
    }
    
    enum Ayahs {
        struct Response: Decodable {
            let number: Int
            let text: String
            let surah: Surah.Response
            let numberInSurah: Int
            let juz: Int
            let manzil: Int
            let page: Int
            let ruku: Int
            let hizbQuarter: Int
        }
    }
    
    enum MetaData {
        
        struct Response: Decodable {
            let ayahs: Ayah
            let pages: Page
            let hizbQuarters: HizbQuarter
            let juzs: Juz
            
            struct Ayah: Decodable {
                let count: Int
            }
            
            struct Page: Decodable {
                let count: Int
                let references: [Reference]
                
                struct Reference: Decodable {
                    let page: Int
                    let startAyah: Int
                    let startAyahNumber: Int
                    let endSurah: Int
                    let endAyah: Int
                    let endAyahNumber: Int
                    let wisdomId: String
                    let wisdomEn: String
                    let section: Int
                }
            }
            
            struct HizbQuarter: Decodable {
                let count: Int
                let references: [Reference]
                
                struct Reference: Decodable {
                    let surah: Int
                    let ayah: Int
                }
            }
            
            struct Juz: Decodable {
                let count: Int
                let references: [Reference]
                
                struct Reference: Decodable {
                    let startSurah: Int
                    let startAyah: Int
                    let endSurah: Int
                    let endAyah: Int
                    let startPage: Int
                    let endPage: Int
                }
            }
        }
    }
}
