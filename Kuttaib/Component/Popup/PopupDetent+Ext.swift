//
//  PopupDetent+Ext.swift
//  Kuttaib
//
//  Created by mco on 05/11/26.
//

import UIKit

extension UISheetPresentationController.Detent.Identifier {
    static let normal = Self("normal")
    static let editing = Self("editing")
}

extension UISheetPresentationController.Detent {
    static func percentage(identifier: UISheetPresentationController.Detent.Identifier, value: CGFloat) -> UISheetPresentationController.Detent {
        .custom(identifier: identifier) { context in
            context.maximumDetentValue * value
        }
    }
}
