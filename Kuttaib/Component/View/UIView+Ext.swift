//
//  UIView+Ext.swift
//  Kuttaib
//
//  Created by mco on 27/10/26.
//

import UIKit

extension UIView {
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds

        layer.insertSublayer(
            gradientLayer,
            at: 0
        )
    }
}
