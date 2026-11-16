//
//  NonActiveTargetsCardView.swift
//  Kuttaib
//
//  Created by mco on 16/11/26.
//

import UIKit
import SkeletonView

final class NonActiveTargetsCardView: UIView {
    let title = UILabel()
    let subtitle = UILabel()
    let list: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let emptyIcon = UIIconView()
    let emptyTitle = UILabel()
    let emptySubtitle = UILabel()
    let emptyVStack = UIStackView()
    let emptyView = UIView()
    
    let contentVStack = UIStackView()
    
    private var collectionHeightConstraint: NSLayoutConstraint!
    
    var onDetailTapped: ((TargetModel) -> Void)?
    
    var data: [TargetModel] = []
    var surah: [Quran.Surah.Response] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 17, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .systemGray2
        subtitle.textAlignment = .left
        
        list.delegate = self
        list.dataSource = self
        list.register(NonActiveTargetCell.self, forCellWithReuseIdentifier: NonActiveTargetCell.identifier)
        list.backgroundColor = .clear
        
        emptyIcon.setTintColor(.primaryGreen)
        emptyIcon.setBackgroundColor(.backgroundGreen)
        
        emptyTitle.font = .systemFont(ofSize: 15, weight: .bold)
        emptyTitle.textColor = .primaryGreenPressed
        emptyTitle.textAlignment = .center
        emptyTitle.numberOfLines = 0
        
        emptySubtitle.font = .systemFont(ofSize: 13)
        emptySubtitle.numberOfLines = 0
        emptySubtitle.textAlignment = .center
        emptySubtitle.textColor = .systemGray2
        
        [emptyIcon, emptyTitle, emptySubtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            emptyVStack.addArrangedSubview($0)
        }
        
        emptyVStack.axis = .vertical
        emptyVStack.spacing = 8
        emptyVStack.alignment = .center
        emptyVStack.distribution = .fill
        emptyVStack.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(emptyVStack)
        emptyView.backgroundColor = .white
        emptyView.layer.cornerRadius = 24
        emptyView.layer.borderColor = UIColor.systemGray5.cgColor
        emptyView.layer.borderWidth = 1
        
        [list, emptyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.alignment = .fill
        contentVStack.distribution = .fill
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        [title, subtitle, contentVStack].forEach {
            $0.isSkeletonable = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        collectionHeightConstraint = list.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            subtitle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            subtitle.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            
            contentVStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            contentVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionHeightConstraint,
            
            emptyIcon.heightAnchor.constraint(equalToConstant: 44),
            emptyIcon.widthAnchor.constraint(equalToConstant: 44),
            
            emptyVStack.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 24),
            emptyVStack.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 24),
            emptyVStack.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -24),
            emptyVStack.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -24),
        ])
    }
    
    func configure(title: String, data: [TargetModel], targetStatus: TargetStatus) {
        self.title.text = title
        self.data = data
        
        if data.isEmpty {
            list.isHidden = true
            emptyView.isHidden = false
            
            switch targetStatus {
            case .inActive:
                emptyIcon.setImage(UIImage(systemName: "pause.circle"))
                emptyTitle.text = "Belum ada target nonaktif"
                emptySubtitle.text = "Target yang belum selesai lalu kamu ganti akan muncul di sini, dan bisa diaktifkan lagi."
            case .done:
                emptyIcon.setImage(UIImage(systemName: "checkmark.circle"))
                emptyTitle.text = "Belum ada target selesai"
                emptySubtitle.text = "Selesaikan target aktifmu, dan hasilnya akan tersimpan di sini."
            default:
                break
            }
        } else {
            list.isHidden = false
            emptyView.isHidden = true
            subtitle.text = "\(data.count) target"
            
            let cellHeight: CGFloat = 96
            let spacing: CGFloat = 12
            
            collectionHeightConstraint.constant = CGFloat(data.count) * cellHeight + CGFloat(max(data.count - 1, 0)) * spacing
            
            list.reloadData()
        }
    }
}

extension NonActiveTargetsCardView: UICollectionViewDelegate, UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonActiveTargetCell.identifier, for: indexPath) as! NonActiveTargetCell
        
        let item = data[indexPath.item]
        
        cell.configure(item)
        cell.onRightButtonTapped = { [weak self] in
            self?.onDetailTapped?(item)
        }
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        NonActiveTargetCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
}

extension NonActiveTargetsCardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 96)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

final class NonActiveTargetCell: UICollectionViewCell {
    static let identifier = "NonActiveTargetCell"
    
    let icon = UIIconView()
    
    let surahName = UILabel()
    let badgeLabel = UILabel()
    let badgeView = UIView()
    let topHStack = UIStackView()
    
    let subtitle = UILabel()
    let progressBar = LineProgressView()
    let centerVStack = UIStackView()
    
    let rightButton = UIButton()
    let mainHStack = UIStackView()
    
    var onRightButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        
        icon.configure(iconImage: UIImage(systemName: "book"), iconTintColor: .primaryGreen, background: .backgroundGreen)
        
        surahName.font = .systemFont(ofSize: 16, weight: .bold)
        surahName.textColor = .black
        surahName.textAlignment = .left
        
        badgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        badgeView.addSubview(badgeLabel)
        badgeView.layer.cornerRadius = 12
        
        [surahName, UIView(), badgeView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 4
        topHStack.alignment = .center
        topHStack.distribution = .fill
        
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .systemGray2
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        
        [topHStack, subtitle, progressBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 8
        centerVStack.alignment = .fill
        centerVStack.distribution = .fill
        
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.tintColor = .systemGray2
        
        [icon, centerVStack, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.distribution = .fill
        mainHStack.alignment = .center
        mainHStack.spacing = 16
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 4),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -16),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -4),
            
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            rightButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        rightButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    func configure(_ data: TargetModel) {
        surahName.text = data.surahName
        
        let percentage = CGFloat(data.completedVerseCount ?? 0)/CGFloat(data.totalVerseCount ?? 0)
        let percentageString = String(format: "%.1f%%", percentage * 100)
        
        let subtitleString = "Surah ke-\(data.targetNumber ?? 0) • \(data.completedVerseCount ?? 0)/\(data.totalVerseCount ?? 0) • \(percentageString)"
        
        subtitle.text = subtitleString
        progressBar.progress = percentage
        
        switch data.status {
        case .inActive:
            badgeLabel.text = "Nonaktif"
            badgeLabel.textColor = .systemGray2
            badgeView.backgroundColor = .systemGray5
        case .done:
            badgeLabel.text = "Selesai"
            badgeLabel.textColor = .primaryGreen
            badgeView.backgroundColor = .backgroundGreen
        default:
            break
        }
    }
    
    @objc private func onButtonTapped() {
        onRightButtonTapped?()
    }
}
