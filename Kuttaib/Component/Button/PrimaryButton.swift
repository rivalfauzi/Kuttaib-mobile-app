//
//  PrimaryButton.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class PrimaryButton: UIButton {
    private var heightConstraint: NSLayoutConstraint!
    private var color: UIColor = .primaryGreen {
        didSet {
            backgroundColor = color
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? color.withAlphaComponent(0.8) : color
            
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setup()
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .primaryGreen
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        
        layer.cornerRadius = 16
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 56)
        heightConstraint.isActive = true
    }
    
    func updateTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    func setHeight(_ height: CGFloat) {
        heightConstraint.constant = height
    }
    
    func setColor(_ color: UIColor, titleColor: UIColor? = nil) {
        self.color = color
        
        if let titleColor {
            setTitleColor(titleColor, for: .normal)
        }
    }
}
