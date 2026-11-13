//
//  ActiveTargetsCardView.swift
//  Kuttaib
//
//  Created by mco on 13/11/26.
//

import UIKit

final class ActiveTargetsCardView: UIView {
    private let contentView = UIView()
    private let mainVStack = UIStackView()
    
    private let activeBadgeBackground = UIView()
    private let activeBadgeLabel = UILabel()
    private let chevronRight = UIImageView()
    private let topHStack = UIStackView()
    
    private let targetTitle = UILabel()
    private let targetDesc = UILabel()
    private let progressBar = LineProgressView()
    private let contentVStack = UIStackView()
    private let contentContainer = UIView()
    
    // empty state
    private let emptyTitle = UILabel()
    private let emptyDesc = UILabel()
    private let emptyButton = PrimaryButton(title: "Pilih Target")
    private let emptyVStack = UIStackView()
    private let emptyContainer = UIView()
    
    var onDetailButtonTapped: (() -> Void)?
    var onNewTargetTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        activeBadgeLabel.text = "Aktif"
        activeBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        activeBadgeLabel.textColor = .primaryGreen
        activeBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        activeBadgeBackground.addSubview(activeBadgeLabel)
        activeBadgeBackground.backgroundColor = .backgroundGreen
        activeBadgeBackground.layer.cornerRadius = 12
        
        chevronRight.image = UIImage(systemName: "chevron.right")
        chevronRight.tintColor = .systemGray2
        chevronRight.contentMode = .scaleAspectFit
        
        [activeBadgeBackground, UIView(), chevronRight].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.distribution = .fill
        topHStack.alignment = .fill
        topHStack.spacing = 4
        
        targetTitle.font = .systemFont(ofSize: 26, weight: .bold)
        targetTitle.textColor = .black
        
        targetDesc.font = .systemFont(ofSize: 13)
        targetDesc.textColor = .systemGray2
        targetDesc.numberOfLines = 0
        
        [topHStack, targetTitle, targetDesc, progressBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.spacing = 8
        contentVStack.alignment = .fill
        contentVStack.distribution = .fill
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onMainButtonTap))
        
        contentContainer.addSubview(contentVStack)
        contentContainer.isUserInteractionEnabled = true
        contentContainer.addGestureRecognizer(tapGesture)
        
        emptyTitle.font = .systemFont(ofSize: 16, weight: .bold)
        emptyTitle.textColor = .black
        emptyTitle.textAlignment = .center
        emptyTitle.numberOfLines = 0
        emptyTitle.text = "Tidak ada target aktif"
        
        emptyDesc.font = .systemFont(ofSize: 13)
        emptyDesc.textColor = .systemGray2
        emptyDesc.textAlignment = .center
        emptyDesc.numberOfLines = 0
        emptyDesc.text = "Pilih target baru, atau aktifkan kembali target nonaktif di bawah."
        
        [emptyTitle, emptyDesc, emptyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            emptyVStack.addArrangedSubview($0)
        }
        
        emptyVStack.axis = .vertical
        emptyVStack.spacing = 16
        emptyVStack.alignment = .fill
        emptyVStack.distribution = .fill
        emptyVStack.translatesAutoresizingMaskIntoConstraints = false
        
        emptyContainer.addSubview(emptyVStack)
        emptyContainer.isHidden = true
        
        [contentContainer, emptyContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainVStack)
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        
        [contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            activeBadgeLabel.topAnchor.constraint(equalTo: activeBadgeBackground.topAnchor, constant: 8),
            activeBadgeLabel.leadingAnchor.constraint(equalTo: activeBadgeBackground.leadingAnchor, constant: 16),
            activeBadgeLabel.trailingAnchor.constraint(equalTo: activeBadgeBackground.trailingAnchor, constant: -16),
            activeBadgeLabel.bottomAnchor.constraint(equalTo: activeBadgeBackground.bottomAnchor, constant: -8),
            
            chevronRight.heightAnchor.constraint(equalToConstant: 24),
            chevronRight.widthAnchor.constraint(equalToConstant: 24),
            
            contentVStack.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            
            emptyVStack.topAnchor.constraint(equalTo: emptyContainer.topAnchor),
            emptyVStack.leadingAnchor.constraint(equalTo: emptyContainer.leadingAnchor),
            emptyVStack.trailingAnchor.constraint(equalTo: emptyContainer.trailingAnchor),
            emptyVStack.bottomAnchor.constraint(equalTo: emptyContainer.bottomAnchor),
        ])
        
        emptyButton.addTarget(self, action: #selector(onNewTargetTap), for: .touchUpInside)
    }
    
    func configure(_ data: TargetModel?, surah: Quran.Surah.Response? = nil) {
        if let data {
            contentContainer.isHidden = false
            emptyContainer.isHidden = true
            targetTitle.text = surah?.englishName
            contentView.layer.borderColor = UIColor.primaryGreen.cgColor
            contentView.backgroundColor = .backgroundGreen.withAlphaComponent(0.2)
            
            let percentage = CGFloat(data.completedVerseCount ?? 0)/CGFloat(data.totalVerseCount ?? 0)
            
            targetDesc.text = "Surah ke-\(data.targetNumber ?? 0) • \(data.completedVerseCount ?? 0) / \(data.totalVerseCount ?? 0) ayat • \(String(format: "%.1f%%", percentage * 100))"
            progressBar.progress = percentage
        } else {
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
            contentView.backgroundColor = .white
            contentContainer.isHidden = true
            emptyContainer.isHidden = false
        }
    }
    
    @objc private func onMainButtonTap() {
        onDetailButtonTapped?()
    }
    
    @objc private func onNewTargetTap() {
        onNewTargetTapped?()
    }
}
