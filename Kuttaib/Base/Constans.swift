//
//  Constans.swift
//  Kuttaib
//
//  Created by mco on 20/11/26.
//

import Foundation

enum Endpoint {
    static let baseURL = "http://localhost:8080/api"
    
    enum Juz {
        private static let mainPath = "/juz"
        
        case JuzList
        
        var path: String {
            switch self {
            case .JuzList:
                return "/list"
            }
        }
        
        var url: URL {
            URL(string: baseURL + Self.mainPath + path)!
        }
    }
    
    enum Surah {
        private static let mainPath = "/surah"
        
        case SurahList
        
        var path: String {
            switch self {
            case .SurahList:
                return "/list"
            }
        }
        
        var url: URL {
            URL(string: baseURL + Self.mainPath + path)!
        }
    }

    enum Onboarding {
        private static let mainPath = "/onboarding"
        
        case CreateTargetOnboarding
        case CreateGuestUser
        
        var path: String {
            switch self {
            case .CreateTargetOnboarding:
                return "/create-target"
            case .CreateGuestUser:
                return "/guests"
            }
        }
        
        var url: URL {
            URL(string: baseURL + Self.mainPath + path)!
        }
    }
    
}
