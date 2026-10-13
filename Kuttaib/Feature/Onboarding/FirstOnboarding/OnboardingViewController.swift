//
//  OnboardingViewController.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class OnboardingViewController: BaseViewController {
    private let onboardingImage = UIImageView()
    private let gradientView = UIView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let nextButton = PrimaryButton(title: "Mulai Sekarang")
    private let VStack = UIStackView()
    
    private let gradientLayer = CAGradientLayer()
    
    var presenter: OnboardingPresenter
    
    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .onboardingBackground
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradientLayer.frame = gradientView.bounds
    }
    
    private func setup() {
        onboardingImage.image = UIImage(named: "onboardingImage")
        onboardingImage.contentMode = .scaleAspectFill
        onboardingImage.clipsToBounds = true
        
        titleLabel.text = "Dekat Dengan Al-Qur'an"
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        descLabel.text = "Satu Tugas dalam Satu Waktu"
        descLabel.font = .systemFont(ofSize: 20, weight: .medium)
        descLabel.textColor = .white
        descLabel.numberOfLines = 0
        
        [titleLabel, descLabel, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            VStack.addArrangedSubview($0)
        }
        
        VStack.axis = .vertical
        VStack.distribution = .fill
        VStack.alignment = .fill
        VStack.spacing = 24
        VStack.setCustomSpacing(8, after: titleLabel)
        
        [onboardingImage, gradientView, VStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            onboardingImage.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            gradientView.topAnchor.constraint(equalTo: onboardingImage.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: onboardingImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: onboardingImage.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: onboardingImage.bottomAnchor),
            
            VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            VStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.onboardingBackground.withAlphaComponent(0.3).cgColor,
            UIColor.onboardingBackground.withAlphaComponent(0.8).cgColor,
            UIColor.onboardingBackground.cgColor
        ]

        gradientLayer.locations = [
            0.0,
            0.55,
            0.8,
            1.0
        ]

        gradientView.layer.addSublayer(gradientLayer)
        
        nextButton.addTarget(self, action: #selector(onNextbuttonTapped), for: .touchUpInside)
    }
    
    @objc private func onNextbuttonTapped() {
        presenter.nextButtonTapped()
    }
}
