//
//  MemorizeAyahSections.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class MemorizeAyahSections: UIView {
    let arabicText = UILabel()
    let latinText = UILabel()
    let translateText = UILabel()
    let translateVStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        arabicText.font = UIFont(name: "KFGQPCUthmanicScriptHAFS", size: 32)
        arabicText.textColor = .black
        arabicText.textAlignment = .center
        arabicText.numberOfLines = 0
        
        latinText.font = .systemFont(ofSize: 16)
        latinText.numberOfLines = 0
        latinText.textAlignment = .center
        latinText.textColor = .systemGray2
        
        translateText.font = .systemFont(ofSize: 16)
        translateText.numberOfLines = 0
        translateText.textAlignment = .center
        translateText.textColor = .black
        
        [arabicText, latinText, translateText].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            translateVStack.addArrangedSubview($0)
        }
        
        translateVStack.axis = .vertical
        translateVStack.spacing = 16
        translateVStack.alignment = .fill
        translateVStack.distribution = .fill
        translateVStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(translateVStack)
        
        NSLayoutConstraint.activate([
            translateVStack.topAnchor.constraint(equalTo: topAnchor),
            translateVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            translateVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            translateVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setText(arabic: String, latin: String, translate: String) {
        arabicText.text = arabic
        latinText.text = latin
        translateText.text = translate
    }
}
