//
//  TargetPickerCell.swift
//  Kuttaib
//
//  Created by mco on 19/11/26.
//

import UIKit

struct TargetPickerCellEntity: Equatable {
    var id: String
    var title: String
    var subtitle: String
    var targetNumber: Int
    var type: TargetType
    var totalCount: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.targetNumber == rhs.targetNumber &&
        lhs.type == rhs.type
    }
}

final class TargetPickerCell: UITableViewCell {
    static let identifier = "TargetPickerCell"
    
    private let indexLabel = UILabel()
    private let indexBackground = UIView()
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let centerVStack = UIStackView()
    
    private let rightImage = UIImageView()
    private let mainHStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var isSelectedTarget = false {
        didSet {
            updateView()
        }
    }

    private func setupView() {
        indexLabel.font = .systemFont(ofSize: 15, weight: .bold)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        indexBackground.addSubview(indexLabel)
        indexBackground.layer.cornerRadius = 12
        
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .systemGray2
        subtitle.textAlignment = .left
        
        [title, subtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 4
        centerVStack.alignment = .fill
        centerVStack.distribution = .fill
        
        rightImage.contentMode = .scaleAspectFit
        
        [indexBackground, centerVStack, rightImage].forEach {
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
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            indexBackground.heightAnchor.constraint(equalToConstant: 40),
            indexBackground.widthAnchor.constraint(equalToConstant: 40),
            
            indexLabel.centerXAnchor.constraint(equalTo: indexBackground.centerXAnchor),
            indexLabel.centerYAnchor.constraint(equalTo: indexBackground.centerYAnchor),
            
            rightImage.heightAnchor.constraint(equalToConstant: 24),
            rightImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setConfigurasi(_ item: TargetPickerCellEntity) {
        indexLabel.text = "\(item.targetNumber)"
        title.text = item.title
        subtitle.text = item.subtitle
    }
    
    private func updateView() {
        if isSelectedTarget {
            contentView.backgroundColor = .backgroundGreen
            indexLabel.textColor = .white
            indexBackground.backgroundColor = .primaryGreen
            rightImage.image = UIImage(systemName: "checkmark.circle.fill")
            rightImage.tintColor = .primaryGreen
        } else {
            contentView.backgroundColor = .white
            indexLabel.textColor = .systemGray2
            indexBackground.backgroundColor = .systemGray5
            rightImage.image = UIImage(systemName: "circle")
            rightImage.tintColor = .systemGray2
        }
    }
}
