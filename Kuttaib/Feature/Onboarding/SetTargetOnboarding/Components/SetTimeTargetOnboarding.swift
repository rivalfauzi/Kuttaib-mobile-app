//
//  SetTimeTargetOnboarding.swift
//  Kuttaib
//
//  Created by mco on 23/11/26.
//

import UIKit

final class SetTimeTargetOnboarding: UIViewController {
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let topVStack = UIStackView()
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    private let nextButton = PrimaryButton(title: "Hitung Target")
    
    private var selectedIndex: Int?
    private var selectedTarget: GeneralTargetEntity?
    private var items: [GeneralTargetEntity] = []
    
    var didNext: ((GeneralTargetEntity)->Void)?
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "Berapa waktu yang bisa kamu luangkan setiap hari?"
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = "Kami akan menyesuaikan tugas hafalan dengan waktu yang kamu piilh."
        
        [titleLabel, descLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topVStack.addArrangedSubview($0)
        }
        
        topVStack.axis = .vertical
        topVStack.distribution = .fill
        topVStack.alignment = .center
        topVStack.spacing = 24
        
        nextButton.isEnabled = false
        
        [topVStack, contentCollectionView, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topVStack.topAnchor.constraint(equalTo: view.topAnchor),
            topVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentCollectionView.topAnchor.constraint(equalTo: topVStack.bottomAnchor, constant: 24),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextButton.topAnchor.constraint(equalTo: contentCollectionView.bottomAnchor, constant: 24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setConfigCollectionView()
        nextButton.addTarget(self, action: #selector(didNextButtonTapped), for: .touchUpInside)
    }
    
    private func setConfigCollectionView() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = .clear
        
        contentCollectionView.register(GeneralTargetCell.self, forCellWithReuseIdentifier: GeneralTargetCell.identifier)
    }
    
    private func updateButton() {
        nextButton.isEnabled = selectedIndex != nil
    }
    
    func setConfiguration(_ item: [GeneralTargetEntity]) {
        items = item
    }
    
    @objc private func didNextButtonTapped() {
        guard let selectedTarget else { return }
        didNext?(selectedTarget)
    }
}

extension SetTimeTargetOnboarding: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralTargetCell.identifier, for: indexPath) as? GeneralTargetCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < items.count {
            let isSelected = selectedIndex == indexPath.item
            cell.setConfig(items[indexPath.item], isSelected: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        let item = items[indexPath.item]
        
        selectedTarget = item
        collectionView.reloadData()
        
        updateButton()
    }
}

extension SetTimeTargetOnboarding: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
