//
//  HomeRecomendationView.swift
//  Kuttaib
//
//  Created by mco on 30/10/26.
//

import UIKit
import SkeletonView

final class HomeRecomendationView: UIView {
    private let title = UILabel()
    private let rightButton = UIButton()
    private let titleHStack = UIStackView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private var collectionHeightConstraint: NSLayoutConstraint!
    
    var onCellButtonTapped: ((HomeRecomendationButtonKey) -> Void)?
    
    private var recomendationData: [HomeRecomendationEntity] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isSkeletonable = true
        title.text = "Rekomendasi"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textAlignment = .left
        
        rightButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        rightButton.setTitle("Lihat Semua", for: .normal)
        rightButton.setTitleColor(.primaryGreen, for: .normal)
        
        [title, UIView(), rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleHStack.addArrangedSubview($0)
        }
        
        titleHStack.axis = .horizontal
        titleHStack.spacing = 0
        titleHStack.alignment = .fill
        titleHStack.distribution = .fill
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeRecomendationCell.self, forCellWithReuseIdentifier: HomeRecomendationCell.identifier)
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton()
        
        [titleHStack, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 180)
        
        NSLayoutConstraint.activate([
            titleHStack.topAnchor.constraint(equalTo: topAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleHStack.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionHeightConstraint
        ])
        
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func setData(_ data: [HomeRecomendationEntity]) {
        recomendationData = data
        collectionView.hideSkeleton(reloadDataAfter: true)
    }
    
    @objc private func rightButtonTapped() {
        print("right button tapped")
    }
}

extension HomeRecomendationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recomendationData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecomendationCell.identifier, for: indexPath) as! HomeRecomendationCell
        let item = recomendationData[indexPath.item]
        cell.config(item)
        cell.onButtonTapped = {[weak self] in
            self?.onCellButtonTapped?(item.buttonKey)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.7
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        HomeRecomendationCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
}

final class HomeRecomendationCell: UICollectionViewCell {
    static let identifier = "HomeRecomendationCell"
    
    private let icon = UIIconView()
    private let title = UILabel()
    private let topHStack = UIStackView()
    private let desc = UILabel()
    private let mainButton = UIButton()
    
    var onButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isSkeletonable = true
        skeletonCornerRadius = 24
        contentView.isSkeletonable = true
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        
        title.textColor = .black
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.numberOfLines = 0
        title.textAlignment = .left
        
        [icon, title].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 16
        topHStack.alignment = .fill
        topHStack.distribution = .fill
        
        desc.font = .systemFont(ofSize: 14)
        desc.numberOfLines = 0
        desc.textColor = .systemGray
        desc.textAlignment = .left
        
        mainButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        mainButton.setTitleColor(.primaryGreen, for: .normal)
        
        [topHStack, desc, mainButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            topHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            topHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            desc.topAnchor.constraint(equalTo: topHStack.bottomAnchor, constant: 16),
            desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            mainButton.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 16),
            mainButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            icon.heightAnchor.constraint(equalToConstant: 32),
            icon.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
    }
    
    func config(_ item: HomeRecomendationEntity) {
        icon.configure(iconImage: UIImage(systemName: item.icon), iconTintColor: item.iconTintColor, background: item.backgroundIcon, cornerRadius: 8)
        
        title.text = item.title
        desc.text = item.description
        mainButton.setTitle(item.buttonTitle, for: .normal)
    }
    
    @objc private func mainButtonTapped() {
        onButtonTapped?()
    }
}
