//
//  DetailTargetViewController.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit
import SkeletonView

final class DetailTargetViewController: BaseViewController {
    private let presenter: DetailTargetPresenter
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainVStack = UIStackView()
    
    private let headerView = DetailHeaderCard()
    private let ayahListView = DaftarAyatView()
    private let mainButton = PrimaryButton(title: "Lanjutkan Tugas Hari Ini")
    
    init(presenter: DetailTargetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupService()
    }
    
    private func setup() {
        title = "Detail Target"
        
        [headerView, ayahListView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        headerView.isSkeletonable = true
        headerView.skeletonCornerRadius = 24
        
        mainVStack.isSkeletonable = true
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainVStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mainButton.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mainButton.addTarget(self, action: #selector(onMainButtonTapped), for: .touchUpInside)
    }
    
    private func setupService() {
        headerView.showAnimatedGradientSkeleton()
        ayahListView.startLoading()
        presenter.fetchData()
    }
    
    private func setupAction() {
        presenter.onGetData = {[weak self] in
            guard let self, let targetData = presenter.targetData, let totalVerseCount = targetData.totalVerseCount, let completedVerseCount = targetData.completedVerseCount else { return }
            
            switch targetData.targetType {
            case .surah:
                guard let surahData = presenter.surahData else { return }
                
                headerView.configure(surahData, target: targetData, user: presenter.userData)
                headerView.hideSkeleton()
            default:
                break
            }
            
            let dataItems = presenter.generateSections(totalVerseCount: totalVerseCount, completedVerseCount: completedVerseCount, tasks: targetData.tasks ?? [])
            ayahListView.configure(dataItems)
            ayahListView.hideSkeleton()
        }
        
        ayahListView.onContinue = {[weak self] item in
            self?.onMainButtonTapped()
        }
    }
    
    @objc private func onMainButtonTapped() {
        presenter.navigateTo(.ziyadahTask)
    }
}
