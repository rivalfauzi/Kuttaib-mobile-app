//
//  SetTargetContainerViewController.swift
//  Kuttaib
//
//  Created by mco on 13/10/26.
//

import UIKit

final class SetTargetContainerViewController: BaseViewController {
    private let backButton = UIButton(type: .system)
    private let stepIndicator = StepIndicatorView()
    private let skipButton = UIButton()
    private let navHStack = UIView()
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    private let nextButton = PrimaryButton(title: "Lanjutkan")

    let presenter: SetTargetPresenter
    var stepIndex = 0

    init(presenter: SetTargetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setup()
        setupAction()
    }
    
    private func setup() {
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        
        stepIndicator.updateTotalSteps(total: presenter.targetData.count)
        stepIndicator.update(step: stepIndex)
        
        skipButton.setTitle("Lewati", for: .normal)
        skipButton.setTitleColor(.primaryGreen, for: .normal)
        
        [backButton, stepIndicator, skipButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            navHStack.addSubview($0)
        }
        
        setConfigCollectionView()
        
        [navHStack, contentCollectionView, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navHStack.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: navHStack.centerYAnchor),
            
            stepIndicator.centerXAnchor.constraint(equalTo: navHStack.centerXAnchor),
            stepIndicator.centerYAnchor.constraint(equalTo: navHStack.centerYAnchor),
            
            skipButton.centerYAnchor.constraint(equalTo: navHStack.centerYAnchor),
            skipButton.trailingAnchor.constraint(equalTo: navHStack.trailingAnchor),
            
            navHStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            navHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            navHStack.heightAnchor.constraint(equalToConstant: 60),
            
            contentCollectionView.topAnchor.constraint(equalTo: navHStack.bottomAnchor, constant: 24),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        contentCollectionView.reloadData()
    }
    
    private func setConfigCollectionView() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.isScrollEnabled = false
        contentCollectionView.isPagingEnabled = true
        contentCollectionView.showsHorizontalScrollIndicator = false
        
        contentCollectionView.register(SetTargetCell.self, forCellWithReuseIdentifier: SetTargetCell.identifier)
    }
    
    private func setupAction() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func scrollToCurrentStep() {
        guard stepIndex >= 0, stepIndex < presenter.targetData.count else {
            return
        }
        
        contentCollectionView.layoutIfNeeded()
        let indexPath = IndexPath(item: stepIndex, section: 0)
        contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        stepIndicator.update(step: stepIndex)
    }
    
    private func setDataStore(_ type: SetTargetViewType, data: MainTargetEntity) {
        switch type {
        case .main:
            break
        case .daily:
            break
        case .time:
            break
        }
    }
    
    @objc private func backButtonTapped() {
        if stepIndex == 0 {
            presenter.navigate(.back)
        } else {
            stepIndex -= 1
            scrollToCurrentStep()
        }
    }
    
    @objc private func nextButtonTapped() {
        if (stepIndex + 1) < presenter.targetData.count {
            stepIndex += 1
            scrollToCurrentStep()
        } else {
            
        }
    }
}

extension SetTargetContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.targetData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetTargetCell.identifier, for: indexPath) as? SetTargetCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < presenter.targetData.count {
            let item = presenter.targetData[indexPath.item]
            
            cell.didSelectItem = { [weak self] index in
                let selectedData = item.items[index]
                self?.setDataStore(item.type, data: selectedData)
            }
            
            cell.setConfiguration(item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
