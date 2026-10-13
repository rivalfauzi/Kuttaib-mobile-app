//
//  PrimaryButton.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class PrimaryButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted
            ? .primaryGreenPressed
            : .primaryGreen
            
            transform = isHighlighted
            ? CGAffineTransform(scaleX: 0.98, y: 0.98)
            : .identity
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
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func updateTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
