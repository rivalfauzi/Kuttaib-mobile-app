//
//  UsernameCard.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit

final class UsernameCard: UIView {
    private let backgroundIcon = UIView()
    private let initialLabel = UILabel()
    private let name = UILabel()
    private let desc = UILabel()
    private let centerVStack = UIStackView()
    private let changeButton = UIButton()
    private let buttonViewContainer = UIView()
    private let mainHStack = UIStackView()
    
    var onTappedChangeButton: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .white
        
        initialLabel.textColor = .white
        initialLabel.font = .systemFont(ofSize: 26, weight: .bold)
        initialLabel.textAlignment = .center
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundIcon.addSubview(initialLabel)
        backgroundIcon.backgroundColor = .primaryGreen
        backgroundIcon.layer.cornerRadius = 48 / 2
        backgroundIcon.clipsToBounds = true
        
        name.font = .systemFont(ofSize: 20, weight: .bold)
        name.textColor = .black
        name.numberOfLines = 0
        name.textAlignment = .left
        
        desc.font = .systemFont(ofSize: 13)
        desc.textColor = .systemGray2
        desc.numberOfLines = 0
        desc.textAlignment = .left
        
        [name, desc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 4
        centerVStack.alignment = .fill
        centerVStack.distribution = .fillEqually
        
        changeButton.setTitle("Ubah", for: .normal)
        changeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        changeButton.setTitleColor(.primaryGreen, for: .normal)
        changeButton.backgroundColor = .white
        changeButton.layer.borderWidth = 1
        changeButton.layer.borderColor = UIColor.primaryGreen.cgColor
        changeButton.layer.cornerRadius = 20
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonViewContainer.addSubview(changeButton)
        
        [backgroundIcon, centerVStack, buttonViewContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.distribution = .fill
        mainHStack.alignment = .fill
        mainHStack.spacing = 16
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            backgroundIcon.heightAnchor.constraint(equalToConstant: 48),
            backgroundIcon.widthAnchor.constraint(equalToConstant: 48),
            
            initialLabel.centerXAnchor.constraint(equalTo: backgroundIcon.centerXAnchor),
            initialLabel.centerYAnchor.constraint(equalTo: backgroundIcon.centerYAnchor),
            
            changeButton.heightAnchor.constraint(equalToConstant: 40),
            changeButton.widthAnchor.constraint(equalToConstant: 89),
            changeButton.centerXAnchor.constraint(equalTo: buttonViewContainer.centerXAnchor),
            changeButton.centerYAnchor.constraint(equalTo: buttonViewContainer.centerYAnchor)
        ])
        
        changeButton.addTarget(self, action: #selector(onChangeButton), for: .touchUpInside)
    }
    
    func configuration(nameString: String) {
        let initial = String(nameString.prefix(1))
        
        name.text = nameString
        initialLabel.text = initial
        desc.text = "Bergabung 03 November 2026"
    }
    
    @objc private func onChangeButton() {
        onTappedChangeButton?()
    }
}
