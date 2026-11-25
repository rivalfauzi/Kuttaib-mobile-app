//
//  SetTargetOnboardingView.swift
//  Kuttaib
//
//  Created by mco on 23/11/26.
//

import UIKit

final class SetTargetOnboardingView: BaseViewController {
    private let stepIndicator = StepIndicatorView()
    private let pagesViewController =  UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let mainTarget = SetMainTargetOnboarding()
    private let dailyTarget = SetDailyTargetOnboarding()
    private let timeTarget = SetTimeTargetOnboarding()
    private lazy var pages: [UIViewController] = [
        mainTarget,
        dailyTarget,
        timeTarget
    ]
    
    let presenter: SetTargetOnboardingPresenter
    private(set) var stepIndex = 0
    
    init(presenter: SetTargetOnboardingPresenter) {
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
    
    private func setup() {
        stepIndicator.updateTotalSteps(total: pages.count)
        stepIndicator.update(step: stepIndex)
        
        navigationItem.titleView = stepIndicator
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        
        addChild(pagesViewController)

        pagesViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        for case let scrollView as UIScrollView in pagesViewController.view.subviews {
            scrollView.isScrollEnabled = false
        }
        
        [pagesViewController.view].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pagesViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagesViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            pagesViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            pagesViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        pagesViewController.didMove(toParent: self)
        mainTarget.setConfiguration(UserOptions.mainTarget)
    }
    
    private func setupAction() {
        mainTarget.didNext = {[weak self] item in
            guard let self, let type = TargetType(rawValue: item.type ?? "") else { return }
            dailyTarget.setConfiguration(UserOptions.dailyVersesTarget, mainTargetType: type)
            presenter.targetDataStore.mainTarget = .init(value: item.value, type: type)
            moveToPage(index: (stepIndex + 1))
        }
        
        dailyTarget.didNext = {[weak self] item in
            guard let self, let type = SetTargetData.DailyTargetType(rawValue: item.type ?? "") else { return }
            timeTarget.setConfiguration(UserOptions.dailyTimeTarget)
            presenter.targetDataStore.dailyTarget = .init(value: item.value, type: type)
            moveToPage(index: (stepIndex + 1))
        }
        
        timeTarget.didNext = {[weak self] item in
            guard let self else { return }
            showLoading()
            presenter.targetDataStore.timeTarget = Int(item.value)
            
            let _ = presenter.createTargetOnboarding { result in
                defer { self.hideLoading() }
                
                switch result {
                case .success(let response):
                    self.presenter.navigateTo(.confirm(response))
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func moveToPage(index: Int) {
        guard index >= 0, index < pages.count, index != stepIndex else { return }

        let direction: UIPageViewController.NavigationDirection = index > stepIndex ? .forward : .reverse

        pagesViewController.setViewControllers(
            [pages[index]],
            direction: direction,
            animated: true
        )

        stepIndex = index
        stepIndicator.update(step: index)
    }
    
    @objc private func backTapped() {
        if stepIndex > 0 {
            switch stepIndex {
            case 1:
                presenter.targetDataStore.dailyTarget = nil
            case 2:
                presenter.targetDataStore.timeTarget = nil
            default:
                break
            }
            
            moveToPage(index: stepIndex - 1)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
