//
//  TargetsViewController.swift
//  Kuttaib
//
//  Created by mco on 12/11/26.
//

import UIKit
import SkeletonView

final class TargetsViewController: BaseViewController {
    let presenter: TargetsPresenter
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainVStack = UIStackView()
    private let titleScreen = UILabel()
    private let activeTarget = ActiveTargetsCardView()
    
    init(presenter: TargetsPresenter) {
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
        self.navigationController?.isNavigationBarHidden = true
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainVStack)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleScreen.text = "Target Saya"
        titleScreen.font = .systemFont(ofSize: 28, weight: .bold)
        titleScreen.textColor = .black
        titleScreen.textAlignment = .left
        
        [titleScreen, activeTarget].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.isSkeletonable = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func fetch() {
        presenter.fetchTarget {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let activeData = response.first {
                    $0.status == .active
                }
                presenter.activeTarget = activeData
                
                presenter.inActiveTargets = response.filter {
                    $0.status == .inActive
                }
                
                presenter.doneTargets = response.filter {
                    $0.status == .done
                }
                
                let surah = presenter.surah.first {
                    $0.number == activeData?.targetNumber
                }
                
                activeTarget.configure(presenter.activeTarget, surah: surah)
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func setupAction() {
        activeTarget.onDetailButtonTapped = {[weak self] in
            guard let self, let userData = presenter.userData else { return }
            presenter.navigateTo(.targetDetail(user: userData))
        }
        
        activeTarget.onNewTargetTapped = {[weak self] in
            guard let self, !presenter.surah.isEmpty else { return }
            let switchTargetBottomSheet = TargetPickerBottomSheet()
            
            switchTargetBottomSheet.setData(presenter.surah)
            switchTargetBottomSheet.userDailyTarget = presenter.userData?.dailyVerseTarget
            
            switchTargetBottomSheet.didSelect = { item in
                
            }
            
            if let presentation = switchTargetBottomSheet.sheetPresentationController {
                presentation.detents = [.large()]
                presentation.prefersGrabberVisible = false
                
                switchTargetBottomSheet.isModalInPresentation = true
                self.present(switchTargetBottomSheet, animated: true)
            }
        }
    }
}
