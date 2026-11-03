//
//  ProfileStatisticCard.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit

final class ProfileStatisticCard: UIView {
    private let title = UILabel()
    private let descLabel = UILabel()
    private let titleHStack = UIStackView()
    
    private let contentView = UIView()
    private let totalAyahComponent = ProfileStatisticComponents()
    private let separator = UIView()
    private let totalDaysComponent = ProfileStatisticComponents()
    private let separator2 = UIView()
    private let strikeComponent = ProfileStatisticComponents()
    private let contentHStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.text = "Perjalananmu"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textAlignment = .left
        
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .systemGray2
        descLabel.text = "Sejak awal"
        descLabel.textAlignment = .right
        
        [title, descLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleHStack.addArrangedSubview($0)
        }
        
        titleHStack.axis = .horizontal
        titleHStack.spacing = 0
        titleHStack.alignment = .fill
        titleHStack.distribution = .fillEqually
        
        separator.backgroundColor = .separator
        separator2.backgroundColor = .separator
        
        [totalAyahComponent, separator, totalDaysComponent, separator2, strikeComponent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentHStack.addArrangedSubview($0)
        }
        
        contentHStack.axis = .horizontal
        contentHStack.spacing = 0
        contentHStack.alignment = .fill
        contentHStack.distribution = .equalSpacing
        contentHStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        contentView.addSubview(contentHStack)
                
        [titleHStack, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleHStack.topAnchor.constraint(equalTo: topAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: titleHStack.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator2.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        totalAyahComponent.setConfig(title: "10", subtitle: "ayat", desc: "Total dihafal", icon: UIImage(systemName: "book.fill"), iconTintColor: .primaryBlue, background: .backgroundBlue)
        totalDaysComponent.setConfig(title: "4", subtitle: "hari", desc: "Total belajar", icon: UIImage(systemName: "chart.line.uptrend.xyaxis"), iconTintColor: .primaryGreen, background: .backgroundGreen)
        strikeComponent.setConfig(title: "4", subtitle: "hari", desc: "Rekor Strike", icon: UIImage(systemName: "flame.fill"), iconTintColor: .primaryRed, background: .backgroundRed)
    }
}

final class ProfileStatisticComponents: UIView {
    private let icon = UIIconView()
    private let value = UILabel()
    private let descValue = UILabel()
    
    private let topHStack = UIStackView()
    private let descComponent = UILabel()
    private let mainVStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        value.font = .systemFont(ofSize: 20, weight: .bold)
        value.textColor = .black
        value.textAlignment = .left
        
        descValue.font = .systemFont(ofSize: 14)
        descValue.textColor = .systemGray2
        descValue.textAlignment = .left
        
        [icon, value, descValue, UIView()].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 4
        topHStack.alignment = .fill
        topHStack.distribution = .fill
        
        descComponent.font = .systemFont(ofSize: 14)
        descComponent.textColor = .systemGray2
        descComponent.textAlignment = .left
        descComponent.numberOfLines = 0
        
        [topHStack, descComponent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 8
        mainVStack.alignment = .center
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.heightAnchor.constraint(equalToConstant: 28),
            icon.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setConfig(title: String, subtitle: String, desc: String, icon: UIImage?, iconTintColor: UIColor, background: UIColor) {
        value.text = title
        descValue.text = subtitle
        descComponent.text = desc
        
        self.icon.configure(iconImage: icon, iconTintColor: iconTintColor, background: background, cornerRadius: 8)
    }
}
