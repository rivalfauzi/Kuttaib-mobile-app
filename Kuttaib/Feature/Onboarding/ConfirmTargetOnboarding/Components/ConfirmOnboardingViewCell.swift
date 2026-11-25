//
//  ConfirmOnboardingViewCell.swift
//  Kuttaib
//
//  Created by mco on 25/11/26.
//

import UIKit

final class ConfirmOnboardingViewCell: UIView {
    
    private let icon = UIIconView()
    private let title = UILabel()
    private let value = UILabel()
    private let desc = UILabel()
    private let valueVStack = UIStackView()
    private let mainHStack = UIStackView()
    
    struct OnboardingTargetData {
        var iconImage: UIImage?
        var title: String
        var value: String
        var desc: String?
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        icon.setBackgroundColor(.systemGray5)
        icon.setTintColor(.primaryGreen)
        
        title.font = .systemFont(ofSize: 13)
        title.textColor = .systemGray2
        
        value.font = .boldSystemFont(ofSize: 19)
        value.textColor = .black
        
        desc.font = .systemFont(ofSize: 13)
        desc.textColor = .systemGray2
        
        [title, value, desc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            valueVStack.addArrangedSubview($0)
        }
        
        valueVStack.axis = .vertical
        valueVStack.spacing = 4
        valueVStack.alignment = .leading
        valueVStack.distribution = .fill
        
        [icon, valueVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 16
        mainHStack.alignment = .center
        mainHStack.distribution = .fill
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 44),
            icon.widthAnchor.constraint(equalToConstant: 44),
            
            mainHStack.topAnchor.constraint(equalTo: topAnchor),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configuration(_ data: OnboardingTargetData) {
        title.text = data.title
        value.text = data.value
        desc.text = data.desc
        desc.isHidden = data.desc == nil
        icon.setImage(data.iconImage)
    }
}
