//
//  HomeTaskCollectionViewCell.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import UIKit
import SkeletonView

final class HomeTaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeTaskCollectionViewCell"
    
    private let icon = UIIconView()
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
        isSkeletonable = true
        skeletonCornerRadius = 24
        
        contentView.isSkeletonable = true
        contentView.skeletonCornerRadius = 24
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        
        title.font = .systemFont(ofSize: 12, weight: .medium)
        subtitle.font = .systemFont(ofSize: 16, weight: .semibold)
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
        
        [icon, centerVStack, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 8
        mainHStack.alignment = .center
        mainHStack.distribution = .fill
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 48),
            icon.widthAnchor.constraint(equalToConstant: 48),
            
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
            title.textColor = .primaryBlue
            
            icon.configure(iconImage: UIImage(systemName: "book.fill"), iconTintColor: .primaryBlue, background: .backgroundBlue)
        case .murojaah:
            title.text = "Murajaah"
            title.textColor = .primaryGreen
            
            icon.configure(iconImage: UIImage(systemName: "arrow.clockwise"), iconTintColor: .primaryGreen, background: .backgroundGreen)
        default:
            break
        }
        
        subtitle.text = "\(surahName) \(item.startAyah ?? 0) - \(item.endAyah ?? 0)"
        
        switch item.status {
        case .notStart:
            rightButton.updateTitle("Mulai")
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
        case .inProgress:
            rightButton.updateTitle("Lanjut")
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
        case .done:
            rightButton.updateTitle("Lihat")
            contentView.backgroundColor = .backgroundGold
            contentView.layer.borderColor = UIColor.primaryGold.cgColor
        default:
            break
        }
    }
    
    @objc private func onButtonTapped() {
        onTappedRightButton?()
    }
}
