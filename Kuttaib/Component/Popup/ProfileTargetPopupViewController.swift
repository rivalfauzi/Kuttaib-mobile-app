//
//  ProfileTargetPopupViewController.swift
//  Kuttaib
//
//  Created by mco on 05/11/26.
//

import UIKit

final class ProfileTargetPopupViewController: UIViewController {
    private let nodeView = UIView()
    private let nodeContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    private let infoIcon = UIImageView()
    private let infoLabel = UILabel()
    private let infoHStack = UIStackView()
    private let saveButton = PrimaryButton(title: "Simpan")
    private let cancelButton = UIButton()
    private let mainVStack = UIStackView()
    
    private let dimmedView = UIView()
    private let containerView = UIView()
    
    private var collectionHeightConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var panGesture: UIPanGestureRecognizer!
    
    var onSaveTapped: ((Int, SetTargetViewType)->Void)?
    
    private var items: [MainTargetEntity] = []
    private var selectedValue: Int?
    private var dataType: SetTargetViewType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        guard collectionHeightConstraint.constant != contentHeight else { return }

        collectionHeightConstraint.constant = contentHeight
    }

    
    private func setup() {
        view.backgroundColor = .clear
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 28
        containerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        
        nodeView.backgroundColor = .systemGray6
        nodeView.translatesAutoresizingMaskIntoConstraints = false
        nodeContainer.addSubview(nodeView)
        
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.font = .systemFont(ofSize: 14)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainTargetCell.self, forCellWithReuseIdentifier: MainTargetCell.identifier)
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        infoIcon.image = UIImage(systemName: "info.circle")
        infoIcon.tintColor = .systemGray2
        infoIcon.contentMode = .scaleAspectFit
        
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .systemGray2
        infoLabel.numberOfLines = 0
        infoLabel.text = "Pastikan target yang dipilih sudah sesuai. Target hafalan hanya bisa diubah sebelum memulai tugas ziyadah hari ini."
        
        [infoIcon, infoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoHStack.addArrangedSubview($0)
        }
        
        infoHStack.axis = .horizontal
        infoHStack.spacing = 8
        infoHStack.alignment = .center
        infoHStack.distribution = .fill
        
        saveButton.setHeight(56)
        
        cancelButton.setTitle("Batal", for: .normal)
        cancelButton.setTitleColor(.primaryGreen, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [nodeContainer, titleLabel, subtitleLabel, collectionView, infoHStack, saveButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(8, after: titleLabel)
        
        containerView.addSubview(mainVStack)
        
        [dimmedView, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nodeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            nodeView.heightAnchor.constraint(equalToConstant: 4),
            nodeView.topAnchor.constraint(equalTo: nodeContainer.topAnchor),
            nodeView.bottomAnchor.constraint(equalTo: nodeContainer.bottomAnchor),
            nodeView.centerXAnchor.constraint(equalTo: nodeContainer.centerXAnchor),
            
            infoIcon.heightAnchor.constraint(equalToConstant: 24),
            infoIcon.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            mainVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            mainVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            collectionHeightConstraint,
            bottomConstraint
        ])
        
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))

        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    func configure(data: [MainTargetEntity], value: Int, title: String, subtitle: String, type: SetTargetViewType, todayZiyadah: Bool) {
        items = data
        selectedValue = value
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        dataType = type
        
        saveButton.isEnabled = !todayZiyadah
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    private func showSheet() {
        dimmedView.alpha = 0
        containerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)

        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8) {
            self.dimmedView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    func dismissSheet() {
        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func onSave() {
        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        } completion: { [weak self] _ in
            guard let self, let selectedValue, let dataType else { return }
            
            self.dismiss(animated: false) {
                self.onSaveTapped?(selectedValue, dataType)
            }
        }
    }
    
    @objc private func onCancel() {
        dismissSheet()
    }
    
    @objc private func backgroundTapped() {
        dismissSheet()
    }
}

extension ProfileTargetPopupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTargetCell.identifier, for: indexPath) as! MainTargetCell
        
        let item = items[indexPath.item]
        let isSelected = selectedValue == item.value
        
        cell.setConfig(item, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedValue = items[indexPath.item].value
        collectionView.reloadData()
    }
}

extension ProfileTargetPopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: 80
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
