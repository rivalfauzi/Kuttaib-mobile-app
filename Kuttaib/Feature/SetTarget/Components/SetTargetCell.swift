//
//  SetTargetCell.swift
//  Kuttaib
//
//  Created by mco on 13/10/26.
//

import UIKit

final class SetTargetCell: UICollectionViewCell {
    static let identifier = "SetTargetCell"
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let topVStack = UIStackView()
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    private var selectedIndex: Int?
    private var items: [MainTargetEntity] = []
    
    var didSelectItem: ((Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        descLabel.text = nil
        items = []
    }
    
    private func setup() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        
        [titleLabel, descLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topVStack.addArrangedSubview($0)
        }
        
        topVStack.axis = .vertical
        topVStack.distribution = .fill
        topVStack.alignment = .center
        topVStack.spacing = 24
        
        [topVStack, contentCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topVStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            topVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            topVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            contentCollectionView.topAnchor.constraint(equalTo: topVStack.bottomAnchor, constant: 24),
            contentCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setConfigCollectionView()
    }
    
    private func setConfigCollectionView() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = .clear
        
        contentCollectionView.register(MainTargetCell.self, forCellWithReuseIdentifier: MainTargetCell.identifier)
    }
    
    func setConfiguration(_ item: SetTargetEntity) {
        titleLabel.text = item.title
        descLabel.text = item.subtitle
        items = item.items
        contentCollectionView.reloadData()
    }
}

extension SetTargetCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTargetCell.identifier, for: indexPath) as? MainTargetCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < items.count {
            let isSelected = indexPath.item == selectedIndex
            cell.setConfig(items[indexPath.item], isSelected: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath.item)
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}

extension SetTargetCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: 100
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
}
