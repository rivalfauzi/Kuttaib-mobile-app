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
    private let sheet = TargetPickerBottomSheet()

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
        initService()
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
        
        sheet.didSelect = { [weak self] index, type in
            guard let self else { return }
            
            setDataStore(.main, data: .init(title: "", subtitle: "", icon: "", populer: false, value: index, type: type))
        }
    }
    
    private func scrollToCurrentStep() {
        guard stepIndex >= 0, stepIndex < presenter.targetData.count else {
            return
        }
        
        if stepIndex == (presenter.targetData.count - 1) {
            nextButton.updateTitle("Mulai Hari Ini")
        } else {
            nextButton.updateTitle("Lanjutkan")
        }
        
        contentCollectionView.layoutIfNeeded()
        let indexPath = IndexPath(item: stepIndex, section: 0)
        contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        stepIndicator.update(step: stepIndex)
    }
    
    private func setDataStore(_ type: SetTargetViewType, data: MainTargetEntity) {
        switch type {
        case .main:
            guard let dataType = data.type,
                let type = SetTargetData.TargetSelectionTab(rawValue: dataType)
            else { return }
            
            presenter.targetDataStore.mainTarget = .init(value: data.value, type: type)
        case .daily:
            guard let dataType = data.type,
                let type = SetTargetData.DailyTargetType(rawValue: dataType)
            else { return }
            
            presenter.targetDataStore.dailyTarget = .init(value: data.value, type: type)
        case .time:
            presenter.targetDataStore.timeTarget = data.value
        case .confirm:
            break
        }
    }
    
    private func initService() {
        showLoading()
        presenter.fetch { [weak self] result in
            guard let self else { return }
            
            hideLoading()
            
            switch result {
            case .success(let response):
                presenter.surahData = response
                sheet.surahItems = response
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
    private func showPopupCustomTarget() {
        if let presentation = sheet.sheetPresentationController, presenter.surahData != nil {
            presentation.detents = [.medium(), .large()]
            presentation.prefersGrabberVisible = true
            present(sheet, animated: true)
        }
    }
    
    private func calculateTargetData() {
        showLoading()
        presenter.fetchQuranMetaData {[weak self] result in
            guard let self else { return }
            hideLoading()
            
            switch result {
            case .success(let response):
                presenter.calculateTarget(response) {
                    self.stepIndex += 1
                    self.scrollToCurrentStep()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
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
        if (stepIndex + 1) < (presenter.targetData.count - 1) {
            stepIndex += 1
            scrollToCurrentStep()
        } else {
            calculateTargetData()
        }
    }
}

extension SetTargetContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.targetData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SetTargetCell.identifier,
            for: indexPath
        ) as! SetTargetCell
        
        if indexPath.item < presenter.targetData.count {
            let item = presenter.targetData[indexPath.item]
            
            cell.didSelectItem = { [weak self] index in
                guard let self else { return }
                let selectedData = item.items[index]
                
                if case .main = item.type, selectedData.title == "Custom" {
                    self.showPopupCustomTarget()
                } else {
                    setDataStore(item.type, data: selectedData)
                }
            }
            
            cell.setConfiguration(item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
