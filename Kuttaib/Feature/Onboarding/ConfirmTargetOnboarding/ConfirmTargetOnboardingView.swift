//
//  ConfirmTargetOnboardingView.swift
//  Kuttaib
//
//  Created by mco on 23/11/26.
//

import UIKit

final class ConfirmTargetOnboardingView: BaseViewController {
    let presenter: ConfirmTargetOnboardingPresenter
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    
    private let contentView = UIView()
    private let mainTargetContainer = ConfirmOnboardingViewCell()
    private let separator1 = UIView()
    private let dailyTargetContainer = ConfirmOnboardingViewCell()
    private let separator2 = UIView()
    private let timeTargetContainer = ConfirmOnboardingViewCell()
    private let separator3 = UIView()
    private let estimatedTargetContainer = ConfirmOnboardingViewCell()
    private let contentVStack = UIStackView()
    
    private let nextButton = PrimaryButton(title: "Mulai Hari Ini")
    private let mainVStack = UIStackView()
    
    init(presenter: ConfirmTargetOnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "Target Hafalan Siap!"
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = "Berikut adalah ringkasan targetmu. Kamu bisa mengubahnya nanti di pengaturan."
        
        [separator1, separator2, separator3].forEach {
            $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
            $0.backgroundColor = .separator
        }
        
        mainTargetContainer.configuration(
            .init(
                iconImage: UIImage(systemName: "book.pages.fill"),
                title: "Target",
                value: presenter.data.targetName ?? "",
                desc: presenter.data.targetDescription
            )
        )
        
        dailyTargetContainer.configuration(
            .init(
                iconImage: UIImage(systemName: "calendar.badge.clock"),
                title: "Target Harian",
                value: presenter.data.dailyTargetString ?? ""
            )
        )
        
        timeTargetContainer.configuration(
            .init(
                iconImage: UIImage(systemName: "clock.fill"),
                title: "Waktu Belajar",
                value: presenter.data.targetDailyTime ?? ""
            )
        )
        
        estimatedTargetContainer.configuration(
            .init(
                iconImage: UIImage(systemName: "calendar"),
                title: "Estimasi Selesai",
                value: presenter.data.estimation ?? ""
            )
        )
        
        [mainTargetContainer, separator1, dailyTargetContainer, separator2, timeTargetContainer, separator3, estimatedTargetContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.distribution = .fill
        contentVStack.alignment = .fill
        contentVStack.spacing = 16
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentVStack)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        
        [titleLabel, descLabel, contentView, UIView()].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.distribution = .fill
        mainVStack.alignment = .fill
        mainVStack.spacing = 24
        
        [mainVStack, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            contentVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nextButton.topAnchor.constraint(equalTo: mainVStack.bottomAnchor, constant: 24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
//        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        presenter.onNextButtonTapped()
    }
}
