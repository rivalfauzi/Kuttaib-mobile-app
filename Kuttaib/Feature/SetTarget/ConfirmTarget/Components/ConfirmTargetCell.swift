//
//  ConfirmTargetCell.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import UIKit

final class ConfirmTargetCell: UITableViewCell {
    static let identifier = "ConfirmTargetCell"
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let icon = UIImageView()
    private let iconBackground = UIView()
    
    private let mainHStack = UIStackView()
    private let labelVStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .primaryGreen
        iconBackground.backgroundColor = .systemGray6
        iconBackground.layer.cornerRadius = 8
        iconBackground.addSubview(icon)
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray2
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.textColor = .black
        
        [titleLabel, subtitleLabel].forEach {
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
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            iconBackground.heightAnchor.constraint(equalToConstant: 48),
            iconBackground.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 28),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
        ])
    }
    
    func configuration(_ item: MainTargetEntity) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        icon.image = UIImage(systemName: item.icon)
    }
}
