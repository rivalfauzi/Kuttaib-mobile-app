//
//  IconView.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit

final class UIIconView: UIView {
    let icon = UIImageView()
    let backgroundIcon = UIView()
    
    private var iconHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        backgroundIcon.layer.cornerRadius = 12
        backgroundIcon.addSubview(icon)
        backgroundIcon.translatesAutoresizingMaskIntoConstraints = false
        
        iconHeightConstraint = icon.heightAnchor.constraint(equalTo: backgroundIcon.heightAnchor, multiplier: 0.6)
        
        addSubview(backgroundIcon)
        
        NSLayoutConstraint.activate([
            backgroundIcon.topAnchor.constraint(equalTo: topAnchor),
            backgroundIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.centerXAnchor.constraint(equalTo: backgroundIcon.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: backgroundIcon.centerYAnchor),
            
            iconHeightConstraint,
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
        ])
    }
    
    func configure(iconImage: UIImage?, iconTintColor: UIColor = .primaryGreen, background: UIColor = .backgroundGreen, ratio: CGFloat = 0.6, cornerRadius: CGFloat = 12) {
        icon.image = iconImage
        icon.tintColor = iconTintColor
        backgroundIcon.backgroundColor = background
        backgroundIcon.layer.cornerRadius = cornerRadius
        
        iconHeightConstraint.isActive = false
        iconHeightConstraint = icon.heightAnchor.constraint(equalTo: backgroundIcon.heightAnchor, multiplier: ratio)
        iconHeightConstraint.isActive = true
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundIcon.backgroundColor = color
    }
    
    func setCornerRadius(_ cornerRadius: CGFloat) {
        backgroundIcon.layer.cornerRadius = cornerRadius
    }
    
    func setImage(_ image: UIImage) {
        icon.image = image
    }
    
    func setTintColor(_ color: UIColor) {
        icon.tintColor = color
    }
}
