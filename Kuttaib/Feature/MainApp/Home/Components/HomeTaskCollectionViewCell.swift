//
//  HomeTaskCollectionViewCell.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import UIKit

final class HomeTaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeTaskCollectionViewCell"
    
    private let backgroundIcon = UIView()
    private let icon = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let rightButton = PrimaryButton(title: "Mulai")
    
    private let centerVStack = UIStackView()
    private let mainHStack = UIStackView()
    
    var onTappedRightButton: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        
        backgroundIcon.layer.cornerRadius = 12
        backgroundIcon.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        
        title.font = .systemFont(ofSize: 14, weight: .medium)
        subtitle.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitle.textColor = .black
        
        [title, subtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.distribution = .equalSpacing
        centerVStack.alignment = .leading
        centerVStack.spacing = 4
        
        rightButton.layer.cornerRadius = 12
        rightButton.setHeight(44)
        
        [backgroundIcon, centerVStack, rightButton].forEach {
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
            backgroundIcon.heightAnchor.constraint(equalToConstant: 48),
            backgroundIcon.widthAnchor.constraint(equalToConstant: 48),
            icon.topAnchor.constraint(equalTo: backgroundIcon.topAnchor, constant: 8),
            icon.leadingAnchor.constraint(equalTo: backgroundIcon.leadingAnchor, constant: 8),
            icon.trailingAnchor.constraint(equalTo: backgroundIcon.trailingAnchor, constant: -8),
            icon.bottomAnchor.constraint(equalTo: backgroundIcon.bottomAnchor, constant: -8),
            
            rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor, multiplier: 1.8),
            
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
        rightButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    func setCofigure(_ item: TaskModel, surahName: String) {
        switch item.type {
        case .ziyadah:
            title.text = "Ziyadah"
            title.textColor = .systemBlue
            backgroundIcon.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            icon.image = UIImage(systemName: "book.fill")
            icon.tintColor = .systemBlue
        case .murojaah:
            title.text = "Murajaah"
            title.textColor = .systemGreen
            backgroundIcon.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            icon.image = UIImage(systemName: "arrow.clockwise")
            icon.tintColor = .systemGreen
        default:
            break
        }
        
        subtitle.text = "\(surahName) \(item.startAyah ?? 0) - \(item.endAyah ?? 0)"
        
        switch item.status {
        case .notStart:
            rightButton.updateTitle("Mulai")
        case .inProgress:
            rightButton.updateTitle("Lanjut")
        case .done:
            rightButton.updateTitle("Lihat")
        default:
            break
        }
    }
    
    @objc private func onButtonTapped() {
        onTappedRightButton?()
    }
}
