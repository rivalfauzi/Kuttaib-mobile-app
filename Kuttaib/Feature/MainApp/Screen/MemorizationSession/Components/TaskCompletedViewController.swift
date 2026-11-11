//
//  TaskCompletedViewController.swift
//  Kuttaib
//
//  Created by mco on 28/10/26.
//


import UIKit

final class TaskCompletedViewController: UIViewController {

    var onContinue: (() -> Void)?
    var onFinish: (() -> Void)?

    private let dimView = UIView()
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let badgeLabel = UILabel()
    private let badgeView = UIView()
    private let badgeContainer = UIView()
    private let continueButton = PrimaryButton(title: "Lanjut")
    private let finishButton = UIButton()
    private let mainVStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        view.addSubview(dimView)
        view.addSubview(containerView)

        dimView.frame = view.bounds
        containerView.backgroundColor = .warmBackground
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(named: "il-done-task")
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.text = "Alhamdulillah!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        descriptionLabel.text = "Seluruh ayat pada tugas hari ini sudah kamu selesaikan."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .secondaryLabel
        
        badgeLabel.font = .systemFont(ofSize: 13, weight: .bold)
        badgeLabel.textColor = .primaryGreen
        badgeLabel.numberOfLines = 0
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        badgeView.addSubview(badgeLabel)
        badgeView.layer.cornerRadius = 12
        badgeView.backgroundColor = .backgroundGreen
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        badgeContainer.addSubview(badgeView)
        
        if let badgeText = badgeLabel.text, !badgeText.isEmpty {
            badgeContainer.isHidden = false
        } else {
            badgeContainer.isHidden = true
        }
        
        finishButton.setTitle("Selesai untuk saat ini", for: .normal)
        finishButton.setTitleColor(.primaryGreen, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [iconView, titleLabel, descriptionLabel, badgeContainer, continueButton, finishButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainVStack)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            iconView.widthAnchor.constraint(equalToConstant: 150),
            iconView.heightAnchor.constraint(equalToConstant: 150),
            
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 8),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 16),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -16),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -8),
            badgeView.topAnchor.constraint(equalTo: badgeContainer.topAnchor),
            badgeView.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor),
            
            badgeView.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
        ])
    }
    
    func setupAction() {
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
    }
    
    func setBadge(_ text: String) {
        badgeView.isHidden = false
        badgeLabel.text = text
    }

    @objc func continueTapped() {
        dismiss(animated: false)
        onContinue?()
    }

    @objc func finishTapped() {
        dismiss(animated: false)
        onFinish?()
    }
    
    func showAnimation() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
}
