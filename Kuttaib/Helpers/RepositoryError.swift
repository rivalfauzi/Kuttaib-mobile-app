//
//  RepositoryError.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation

enum RepositoryError: LocalizedError {
    case activeTargetExists
    case activeTargetNotFound
    case updateFailed
    case dataNotFound

    var errorDescription: String? {
        switch self {
        case .activeTargetExists:
            return "Masih ada target aktif"
        case .activeTargetNotFound:
            return "Belum ada target aktif"
        case .updateFailed:
            return "Gagal mengupdate data"
        case .dataNotFound:
            return "Data tidak ditemukan"
        }
    }
}
