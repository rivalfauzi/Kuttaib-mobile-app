//
//  HomeRecomendationView.swift
//  Kuttaib
//
//  Created by mco on 30/10/26.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
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
    
    @objc private func rightButtonTapped() {
        print("right button tapped")
    }
}

extension HomeRecomendationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecomendationCell.identifier, for: indexPath) as! HomeRecomendationCell
        cell.config(HomeRecomendationEntity(
            icon: "book.fill",
            iconTintColor: .primaryBlue,
            backgroundIcon: .backgroundBlue,
            title: "Atur Pengingat Hafalan",
            description: "Pilih jam favoritmu supaya fokus hafalan tidak terlewat. Bisa diatur kapan saja di Profil.",
            buttonTitle: "Atur di Profil")
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.7
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
}

final class HomeRecomendationCell: UICollectionViewCell {
    static let identifier = "HomeRecomendationCell"
    
    private let icon = UIImageView()
    private let backgroundIcon = UIView()
    private let title = UILabel()
    private let topHStack = UIStackView()
    private let desc = UILabel()
    private let mainButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        
        backgroundIcon.layer.cornerRadius = 12
        backgroundIcon.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.textAlignment = .left
        
        [backgroundIcon, title].forEach {
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
        
        mainButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
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
            
            backgroundIcon.heightAnchor.constraint(equalToConstant: 32),
            backgroundIcon.widthAnchor.constraint(equalToConstant: 32),
            icon.topAnchor.constraint(equalTo: backgroundIcon.topAnchor, constant: 8),
            icon.leadingAnchor.constraint(equalTo: backgroundIcon.leadingAnchor, constant: 8),
            icon.trailingAnchor.constraint(equalTo: backgroundIcon.trailingAnchor, constant: -8),
            icon.bottomAnchor.constraint(equalTo: backgroundIcon.bottomAnchor, constant: -8),
        ])
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
    }
    
    func config(_ item: HomeRecomendationEntity) {
        icon.image = UIImage(systemName: item.icon)
        icon.tintColor = item.iconTintColor
        backgroundIcon.backgroundColor = item.backgroundIcon
        title.text = item.title
        desc.text = item.description
        mainButton.setTitle(item.buttonTitle, for: .normal)
    }
    
    @objc private func mainButtonTapped() {
        print("mainButtonTapped")
    }
}
