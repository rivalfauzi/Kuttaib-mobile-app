//
//  BottomSheetViewController.swift
//  Kuttaib
//
//  Created by mco on 16/11/26.
//


import UIKit

final class BottomSheetViewController: UIViewController {
    private let dimmedView = UIView()
    private let containerView = UIView()

    private let handleView = UIView()
    private let handleViewContainer = UIView()

    private let contentContainer = UIView()

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSheet()
    }

    func setContent(_ view: UIView) {
        contentContainer.subviews.forEach {
            $0.removeFromSuperview()
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
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

        handleView.backgroundColor = .systemGray5
        handleView.layer.cornerRadius = 2
        handleView.translatesAutoresizingMaskIntoConstraints = false
        
        handleViewContainer.addSubview(handleView)

        let stackView = UIStackView(arrangedSubviews: [handleViewContainer, contentContainer])

        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [dimmedView, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),

            handleView.widthAnchor.constraint(equalToConstant: 80),
            handleView.heightAnchor.constraint(equalToConstant: 4),
            handleView.topAnchor.constraint(equalTo: handleViewContainer.topAnchor),
            handleView.bottomAnchor.constraint(equalTo: handleViewContainer.bottomAnchor),
            handleView.centerXAnchor.constraint(equalTo: handleViewContainer.centerXAnchor),
        ])

        handleView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        dimmedView.addGestureRecognizer(tap)
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
            self.containerView.transform = CGAffineTransform(
                translationX: 0,
                y: self.view.bounds.height
            )
        } completion: { _ in
            self.dismiss(animated: false)
            self.onDismiss?()
        }
    }

    @objc private func backgroundTapped() {
        dismissSheet()
    }
}
