//
//  PopupAlertSetTarget.swift
//  Kuttaib
//
//  Created by mco on 19/11/26.
//

import UIKit

final class PopupAlertSetTarget: UIView {
    let title = UILabel()
    let subtitle = UILabel()
    
    let badgeTitleLabel = UILabel()
    let badgeDescriptionLabel = UILabel()
    let topHStack = UIStackView()
    let progressBar = LineProgressView()
    let badgeVStack = UIStackView()
    let badgeView = UIView()
    
    let continueButton = PrimaryButton(title: "")
    let secondButton = PrimaryButton(title: "")
    let thirdButton = PrimaryButton(title: "Batal")
    
    let mainVStack = UIStackView()
    
    var onClose: (() -> Void)?
    var onRestart: (() -> Void)?
    var onContinue: (() -> Void)?
    
    var data: TargetModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        title.font = .systemFont(ofSize: 22, weight: .semibold)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .systemGray2
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        
        continueButton.setColor(.primaryGreen, titleColor: .white)
        secondButton.setColor(.white, titleColor: .primaryGreen)
        secondButton.layer.borderColor = UIColor.primaryGreen.cgColor
        secondButton.layer.borderWidth = 1
        thirdButton.setColor(.white, titleColor: .primaryGreen)
        thirdButton.setHeight(44)
        
        badgeTitleLabel.font = .systemFont(ofSize: 14)
        badgeTitleLabel.textColor = .systemGray
        badgeTitleLabel.text = "Progress sebelumnya"
        badgeTitleLabel.textAlignment = .left
        
        badgeDescriptionLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        badgeDescriptionLabel.textColor = .black
        badgeDescriptionLabel.textAlignment = .right
        badgeDescriptionLabel.numberOfLines = 0
        
        [badgeTitleLabel, badgeDescriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.distribution = .fill
        topHStack.alignment = .bottom
        
        [topHStack, progressBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            badgeVStack.addArrangedSubview($0)
        }
        
        badgeVStack.axis = .vertical
        badgeVStack.spacing = 8
        badgeVStack.alignment = .fill
        badgeVStack.distribution = .fill
        badgeVStack.translatesAutoresizingMaskIntoConstraints = false
        
        badgeView.addSubview(badgeVStack)
        badgeView.layer.cornerRadius = 16
        badgeView.backgroundColor = .backgroundGreen
        badgeView.layer.borderColor = UIColor.primaryGreen.cgColor
        badgeView.layer.borderWidth = 1
        
        [title, badgeView, subtitle, continueButton, secondButton, thirdButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 12
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(24, after: subtitle)
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            badgeVStack.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 16),
            badgeVStack.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 16),
            badgeVStack.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -16),
            badgeVStack.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -16),
        ])
        
        thirdButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(onSecondButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(onMainButtonTapped), for: .touchUpInside)
    }
    
    func configure(_ data: TargetModel) {
        self.data = data
        
        switch data.status {
        case .inActive:
            title.text = "\(data.surahName ?? "") sudah pernah kamu mulai"
            badgeView.isHidden = false
            
            let percentage = CGFloat(data.completedVerseCount ?? 0)/CGFloat(data.totalVerseCount ?? 0)
            
            badgeDescriptionLabel.text = "\(String(format: "%.1f%%", percentage * 100))"
            progressBar.progress = percentage
            
            subtitle.text = "Lanjutkan dari ayat \((data.completedVerseCount ?? 0) + 1), atau mulai ulang dari awal. Jika mulai ulang, progres sebelumnya diganti."
            continueButton.updateTitle("Lanjutkan")
            secondButton.updateTitle("Ulangi")
            thirdButton.isHidden = false
        case .done:
            title.text = "\(data.surahName ?? "") sudah kamu selesaikan"
            badgeView.isHidden = true
            subtitle.text = "Kamu pernah menyelesaikan surah ini (\(data.totalVerseCount ?? 0) ayat). Jika mengulang, kamu mulai lagi dari ayat 1 dan riwayat sebelumnya tetap tersimpan."
            continueButton.updateTitle("Ulangi")
            secondButton.updateTitle("Kembali")
            thirdButton.isHidden = true
        default:
            break
        }
    }
    
    @objc private func onMainButtonTapped() {
        if data?.status == .inActive {
            onContinue?()
        } else if data?.status == .done {
            onRestart?()
        }
    }
    
    @objc private func onSecondButtonTapped() {
        if data?.status == .inActive {
            onRestart?()
        } else if data?.status == .done {
            onClose?()
        }
    }
    
    @objc private func onCloseTapped() {
        onClose?()
    }
}
