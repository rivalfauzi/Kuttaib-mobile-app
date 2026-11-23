//
//  SnackbarType.swift
//  Kuttaib
//
//  Created by mco on 20/11/26.
//

import UIKit

enum SnackbarType {
    case success
    case error
    case warning

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return .backgroundGreen
        case .error:
            return .backgroundRed
        case .warning:
            return .backgroundYellow
        }
    }

    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle.fill")
        case .error:
            return UIImage(systemName: "xmark.circle.fill")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle.fill")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .error:
            return .primaryRed
        case .success:
            return .primaryGreen
        case .warning:
            return .primaryGold
        }
    }
}
