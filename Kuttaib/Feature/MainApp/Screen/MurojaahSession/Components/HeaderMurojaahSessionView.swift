//
//  HeaderMurojaahSessionView.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit

final class HeaderMurojaahSessionView: UIView {
    let title = UILabel()
    let badge = HeaderMurojaahBadge()
    let mainVStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 28, weight: .bold)
        title.textColor = .black
        title.textAlignment = .center
        
        [title, badge].forEach {
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
        ])
    }
    
    func configure(number: Int, count: Int) {
        title.text = "Ayat \(number)"
        badge.configure(count)
    }
}

final class HeaderMurojaahBadge: UIView {
    let icon = UIImageView()
    let label = UILabel()
    let mainHStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        layer.cornerRadius = 15
        backgroundColor = .backgroundGreen
        
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .primaryGreen
        
        icon.tintColor = .primaryGreen
        icon.image = UIImage(systemName: "arrow.clockwise")
        icon.contentMode = .scaleAspectFit
        
        [icon, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.distribution = .fill
        mainHStack.alignment = .center
        mainHStack.spacing = 4
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            icon.heightAnchor.constraint(equalToConstant: 14),
            icon.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configure(_ count: Int) {
        if count == 0 {
            label.text = "Belum pernah diulang"
        } else {
            label.text = "Sudah diulang \(count)x"
        }
    }
}
