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

    private let iconView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(named: "il-done-task")
        )
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alhamdulillah!"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Seluruh ayat pada tugas ini berhasil diselesaikan. Mau tambah ayat lagi?"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let countTitle = UILabel()
    private let countDesc = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    
    private let countLabel = UILabel()

    private let continueButton = PrimaryButton(title: "Tambah Ayat")
    private let finishButton = UIButton()
    
    private var ayahCount = 3 {
        didSet {
            countLabel.text = "\(ayahCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
}

private extension TaskCompletedViewController {

    func setupView() {
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        view.addSubview(dimView)
        view.addSubview(containerView)

        dimView.frame = view.bounds
        containerView.backgroundColor = .warmBackground
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        finishButton.setTitle("Selesai untuk saat ini", for: .normal)
        finishButton.setTitleColor(.primaryGreen, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

        [iconView, titleLabel, descriptionLabel, continueButton, finishButton].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 160),
            iconView.heightAnchor.constraint(equalToConstant: 160),
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            continueButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            finishButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 16),
            finishButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            finishButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}

private extension TaskCompletedViewController {

    func setupAction() {
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
    }

    @objc func continueTapped() {
        dismiss(animated: false)
        onContinue?()
    }

    @objc func finishTapped() {
        dismiss(animated: false)
        onFinish?()
    }
}

private extension TaskCompletedViewController {

    func showAnimation() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
}
