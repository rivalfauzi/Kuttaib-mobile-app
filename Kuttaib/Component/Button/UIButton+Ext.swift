//
//  UIButton+Ext.swift
//  Kuttaib
//
//  Created by mco on 27/10/26.
//

import UIKit

extension UIButton {
    func setColorEnable(_ enable: Bool) {
        self.isEnabled = enable
        self.alpha = enable ? 1.0 : 0.5
    }
}
