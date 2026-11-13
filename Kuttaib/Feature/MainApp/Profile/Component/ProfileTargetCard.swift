//
//  ProfileTargetCard.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit
import SkeletonView

final class ProfileTargetCard: UIView {
    private let title = UILabel()
    
    private let targetVStack = UIStackView()
    private let memorizationTarget = ProfileTargetTableCell()
    private let separator = UIView()
    private let dailyTime = ProfileTargetTableCell()
    private let separator2 = UIView()
    private let mainTarget = ProfileTargetTableCell()
    private let contentView = UIView()
    
    var onTargetTapped: ((TargetType) -> Void)?
    
    enum TargetType {
        case memorization
        case dailyTime
        case target
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isSkeletonable = true
        
        title.text = "Target Hafalan"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textAlignment = .left
        
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        contentView.skeletonCornerRadius = 24
        contentView.isSkeletonable = true
        
        separator.backgroundColor = .separator
        separator2.backgroundColor = .separator
        
        [memorizationTarget, separator, dailyTime, separator2, mainTarget].forEach {
            $0.isHidden = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            targetVStack.addArrangedSubview($0)
        }
        
        targetVStack.axis = .vertical
        targetVStack.spacing = 16
        targetVStack.alignment = .fill
        targetVStack.distribution = .fill
        targetVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(targetVStack)
                
        [title, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            targetVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            targetVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            targetVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            targetVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator2.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        memorizationTarget.onTapped = {[weak self] in
            self?.onTargetTapped?(.memorization)
        }
        
        dailyTime.onTapped = {[weak self] in
            self?.onTargetTapped?(.dailyTime)
        }
        
        mainTarget.onTapped = {[weak self] in
            self?.onTargetTapped?(.target)
        }
    }
    
    func configure(subtitle: String, type: TargetType) {
        switch type {
        case .memorization:
            memorizationTarget.isHidden = false
            
            memorizationTarget.configure(icon: UIImage(systemName: "target"), iconTintColor: .primaryGreen, iconBackground: .backgroundGreen, titleString: "Target Harian", subtitleString: subtitle)
            
        case .dailyTime:
            separator.isHidden = false
            dailyTime.isHidden = false
            
            dailyTime.configure(icon: UIImage(systemName: "clock.fill"), iconTintColor: .primaryGold, iconBackground: .backgroundGold, titleString: "Waktu Belajar", subtitleString: subtitle)
            
            if mainTarget.isHidden {
                separator2.isHidden = true
            } else {
                separator2.isHidden = false
            }
        case .target:
            if dailyTime.isHidden {
                separator2.isHidden = true
            } else {
                separator2.isHidden = false
            }
            
            mainTarget.isHidden = false
            
            mainTarget.configure(icon: UIImage(systemName: "book.fill"), iconTintColor: .primaryBlue, iconBackground: .backgroundBlue, titleString: "Target Surah", subtitleString: subtitle)
        }
        
        
    }
}

final class ProfileTargetTableCell: UIView {
    private let icon = UIIconView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let centerVStack = UIStackView()
    private let rightIcon = UIImageView()
    private let rightViewContainer = UIView()
    private let mainHStack = UIStackView()
    private let mainButton = UIButton()
    
    var onTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .systemGray2
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        
        [title, subtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 4
        centerVStack.alignment = .fill
        centerVStack.distribution = .fill
        
        rightIcon.contentMode = .scaleAspectFit
        rightIcon.tintColor = .systemGray
        rightIcon.image = UIImage(systemName: "chevron.right")
        rightIcon.translatesAutoresizingMaskIntoConstraints = false
        rightViewContainer.addSubview(rightIcon)
        
        [icon, centerVStack, rightViewContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.distribution = .fill
        mainHStack.alignment = .fill
        mainHStack.spacing = 16
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.heightAnchor.constraint(equalToConstant: 44),
            icon.widthAnchor.constraint(equalToConstant: 44),
            
            rightIcon.heightAnchor.constraint(equalToConstant: 24),
            rightIcon.widthAnchor.constraint(equalToConstant: 24),
            rightIcon.leadingAnchor.constraint(equalTo: rightViewContainer.leadingAnchor, constant: 4),
            rightIcon.trailingAnchor.constraint(equalTo: rightViewContainer.trailingAnchor, constant: -4),
            rightIcon.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
            
            mainButton.topAnchor.constraint(equalTo: topAnchor),
            mainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        mainButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    func configure(icon: UIImage?, iconTintColor: UIColor, iconBackground: UIColor, titleString: String, subtitleString: String) {
        self.icon.configure(iconImage: icon, iconTintColor: iconTintColor, background: iconBackground)
        
        title.text = titleString
        subtitle.text = subtitleString
    }
    
    @objc private func onButtonTapped() {
        onTapped?()
    }
}
