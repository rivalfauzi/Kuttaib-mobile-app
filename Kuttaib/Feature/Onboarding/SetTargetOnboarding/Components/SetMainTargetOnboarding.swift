//
//  SetMainTargetOnboarding.swift
//  Kuttaib
//
//  Created by mco on 23/11/26.
//

import UIKit

final class SetMainTargetOnboarding: UIViewController {
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let topVStack = UIStackView()
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    private let nextButton = PrimaryButton(title: "Lanjutkan")
    private let sheet = TargetPickerBottomSheet()
    
    private var selectedIndex: Int?
    private var selectedTarget: MainTargetEntity?
    private var items: [MainTargetEntity] = []
    
    var didNext: ((MainTargetEntity)->Void)?
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAction()
    }
    
    private func setup() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "Apa Target Hafalanmu?"
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = "Pilih sesuai kemampuan dan tujuanmu. Tenang, ini bisa diubah nanti."
        
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
        
        contentCollectionView.register(MainTargetCell.self, forCellWithReuseIdentifier: MainTargetCell.identifier)
    }
    
    private func setupAction() {
        sheet.didSelect = { [weak self] item in
            guard let self else { return }
            dismiss(animated: true) {
                let newTarget = MainTargetEntity(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: "",
                    populer: false,
                    value: Double(item.targetNumber),
                    type: item.type.rawValue,
                    iconTintColor: nil,
                    background: nil
                )
                
                self.selectedTarget = newTarget
                self.contentCollectionView.reloadData()
                self.updateButton()
            }
        }
    }
    
    private func updateButton() {
        nextButton.isEnabled = selectedIndex != nil
    }
    
    func setConfiguration(_ item: [MainTargetEntity], selected: MainTargetEntity? = nil) {
        items = item
        selectedTarget = selected
        contentCollectionView.reloadData()
    }
    
    @objc private func didNextButtonTapped() {
        guard let selectedTarget else { return }
        didNext?(selectedTarget)
    }
}

extension SetMainTargetOnboarding: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTargetCell.identifier, for: indexPath) as? MainTargetCell else {
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
        
        if item.value == 0, let presentation = sheet.sheetPresentationController {
            presentation.detents = [.large()]
            presentation.prefersGrabberVisible = false
            
            sheet.isModalInPresentation = true
            present(sheet, animated: true)
        } else {
            let targetPickerCell = TargetPickerCellEntity(id: "", title: item.title, subtitle: item.subtitle, targetNumber: Int(item.value), type: TargetType(rawValue: item.type ?? "") ?? .surah, totalCount: 0)

            sheet.setData(targetPickerCell)
            selectedTarget = item
            collectionView.reloadData()
        }
        
        updateButton()
    }
}

extension SetMainTargetOnboarding: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
