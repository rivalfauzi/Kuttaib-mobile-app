//
//  GeneralAlert.swift
//  Kuttaib
//
//  Created by mco on 16/11/26.
//

import UIKit

final class GeneralAlert: UIViewController {

    private let dimmedView = UIView()
    private let contentContainer = UIView()

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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

    func dismissAlert() {
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0
            self.contentContainer.alpha = 0
            self.contentContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            self.dismiss(animated: false)
            self.onDismiss?()
        }
    }

    private func setup() {
        view.backgroundColor = .clear

        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedView.alpha = 0

        contentContainer.backgroundColor = .clear
        contentContainer.alpha = 0

        [dimmedView, contentContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([

            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )

        dimmedView.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = 1
            self.contentContainer.alpha = 1
            self.contentContainer.transform = .identity
        }
    }

    @objc private func backgroundTapped() {
        dismissAlert()
    }
}
