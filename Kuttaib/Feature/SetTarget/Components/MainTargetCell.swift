//
//  MainTargetCell.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

final class MainTargetCell: UICollectionViewCell {

    static let identifier = "MainTargetCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let icon = UIImageView()
    private let iconBackground = UIView()
    private let badge = UIView()
    private let badgeLabel = UILabel()
    
    private let mainHStack = UIStackView()
    private let labelVStack = UIStackView()
    private let topHStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .white
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .primaryGreen
        iconBackground.backgroundColor = .systemGray6
        iconBackground.layer.cornerRadius = 8
        iconBackground.addSubview(icon)
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.text = "Rekomendasi"
        badgeLabel.font = .systemFont(ofSize: 12)
        badgeLabel.textColor = .white
        badge.backgroundColor = .goldAccent
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true
        badge.addSubview(badgeLabel)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        
        [titleLabel, badge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.distribution = .equalSpacing
        topHStack.alignment = .fill
        topHStack.spacing = 4
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.numberOfLines = 0
        
        [topHStack, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            labelVStack.addArrangedSubview($0)
        }
        
        labelVStack.axis = .vertical
        labelVStack.spacing = 8
        labelVStack.distribution = .fill
        labelVStack.alignment = .fill
        
        [iconBackground, labelVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 16
        mainHStack.alignment = .center
        mainHStack.distribution = .fill
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            iconBackground.heightAnchor.constraint(equalToConstant: 48),
            iconBackground.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 28),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            
            badgeLabel.topAnchor.constraint(equalTo: badge.topAnchor, constant: 4),
            badgeLabel.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 8),
            badgeLabel.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -8),
            badgeLabel.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -4),
        ])
    }
    
    func setConfig(_ item: MainTargetEntity, isSelected: Bool = false) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        icon.image = UIImage(systemName: item.icon)
        badge.isHidden = !item.populer
        
        layer.borderColor = isSelected ? UIColor.primaryGreen.cgColor : UIColor.systemGray5.cgColor
    }
}
