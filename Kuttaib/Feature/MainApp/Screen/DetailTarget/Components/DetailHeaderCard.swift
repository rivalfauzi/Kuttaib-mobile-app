//
//  DetailHeaderCard.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//


import UIKit

final class DetailHeaderCard: UIView {

    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let latinName = UILabel()
    private let detailLabel = UILabel()
    private let leftTopVStack = UIStackView()
    private let spacerView = UIView()
    private let arabicLabel = UILabel()
    private let topHStack = UIStackView()
    
    private let separator = UIView()
    
    private let progressTitleLabel = UILabel()
    private let persentaseLabel = UILabel()
    private let spacerProgressView = UIView()
    private let progressHStack = UIStackView()
    private let progressBar = LineProgressView()
    
    private let progressAyat = UILabel()
    private let estimateLabel = UILabel()
    private let estimateSpacer = UIView()
    private let estimateHStack = UIStackView()
    
    private let mainVStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .white

        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .primaryGreen
        
        latinName.font = .systemFont(ofSize: 28, weight: .bold)
        latinName.textColor = .black
        
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .systemGray2
        
        [titleLabel, latinName, detailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            leftTopVStack.addArrangedSubview($0)
        }
        
        leftTopVStack.axis = .vertical
        leftTopVStack.spacing = 8
        leftTopVStack.alignment = .fill
        leftTopVStack.distribution = .fill

        arabicLabel.font = UIFont(name: "KFGQPCUthmanicScriptHAFS", size: 32)
        arabicLabel.textColor = .primaryGreen
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        [leftTopVStack, spacerView, arabicLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 4
        topHStack.alignment = .fill
        topHStack.distribution = .fill
        
        separator.backgroundColor = .separator
        
        progressTitleLabel.text = "Progress Hafalan"
        progressTitleLabel.font = .systemFont(ofSize: 14)
        progressTitleLabel.textColor = .systemGray2
        progressTitleLabel.numberOfLines = 0
        
        persentaseLabel.font = .systemFont(ofSize: 18, weight: .bold)
        persentaseLabel.textColor = .primaryGreen
        
        spacerProgressView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerProgressView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        [progressTitleLabel, spacerProgressView, persentaseLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            progressHStack.addArrangedSubview($0)
        }
        
        progressHStack.axis = .horizontal
        progressHStack.spacing = 4
        progressHStack.alignment = .bottom
        progressHStack.distribution = .fill
        
        progressAyat.font = .systemFont(ofSize: 14)
        progressAyat.textColor = .systemGray2
        
        estimateLabel.font = .systemFont(ofSize: 14)
        estimateLabel.textColor = .systemGray2
        
        estimateSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        estimateSpacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        [progressAyat, estimateSpacer, estimateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            estimateHStack.addArrangedSubview($0)
        }
        
        estimateHStack.axis = .horizontal
        estimateHStack.spacing = 4
        estimateHStack.alignment = .fill
        estimateHStack.distribution = .fill
        
        [topHStack, separator, progressHStack, progressBar, estimateHStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 16
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(8, after: progressHStack)
        mainVStack.setCustomSpacing(8, after: progressBar)
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func configure(_ data: Quran.Surah.Response, target: TargetModel, user: UserModel) {
        titleLabel.text = "Surah ke-\(data.number)"
        latinName.text = data.englishName
        detailLabel.text = "\(data.revelationType) • \(data.numberOfAyahs) ayat"
        arabicLabel.text = data.name
        
        let percentage = CGFloat(target.completedVerseCount ?? 0)/CGFloat(target.totalVerseCount ?? 0)
        persentaseLabel.text = String(format: "%.1f%%", percentage * 100)
        progressBar.progress = percentage
        
        progressAyat.text = "\(target.completedVerseCount ?? 0)/\(target.totalVerseCount ?? 0) ayat"
        
        let sisa = (target.totalVerseCount ?? 0) - (target.completedVerseCount ?? 0)
        let estimatedDay = (sisa + user.dailyVerseTarget - 1) / user.dailyVerseTarget
        estimateLabel.text = "Sisa \(sisa) ayat • ± \(estimatedDay) hari lagi"
    }
}
