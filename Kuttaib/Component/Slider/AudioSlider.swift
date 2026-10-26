//
//  AudioSlider.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class AudioSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.origin.x, y: bounds.midY - 2, width: bounds.width, height: 4)
    }
    
    func makeThumbImage(diameter: CGFloat, color: UIColor) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))

        let image = renderer.image { context in
            let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            color.setFill()
            UIBezierPath(ovalIn: rect).fill()
        }
        
        setThumbImage(image, for: .normal)
    }
}
