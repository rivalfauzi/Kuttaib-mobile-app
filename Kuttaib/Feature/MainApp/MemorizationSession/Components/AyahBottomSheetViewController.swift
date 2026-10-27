//
//  AyahBottomSheetViewController.swift
//  Kuttaib
//
//  Created by mco on 27/10/26.
//


import UIKit

final class AyahBottomSheetViewController: UIViewController {

    // MARK: - Views

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let translateView = MemorizeAyahSections()

    private let hideButton = PrimaryButton(title: "Sembunyikan Ayat")

    // MARK: - Init

    private let arabic: String
    private let latin: String
    private let translation: String
    private let titleText: String

    init(title: String, arabic: String, latin: String, translation: String) {
        self.titleText = title
        self.arabic = arabic
        self.latin = latin
        self.translation = translation

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupData()
    }

    // MARK: - Setup

    private func setupView() {

        view.backgroundColor = .systemBackground

        [titleLabel, closeButton, scrollView, contentView, translateView, hideButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.text = titleText
        titleLabel.font = .boldSystemFont(ofSize: 24)

        closeButton.setImage(
            UIImage(systemName: "xmark"),
            for: .normal
        )

        closeButton.tintColor = .label
        hideButton.setColor(.systemGray5, titleColor: .primaryGreen)
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(translateView)

        view.addSubview(hideButton)

        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        hideButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    private func setupData() {
        translateView.setText(arabic: arabic, latin: latin, translate: translation)
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            hideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            hideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: hideButton.topAnchor, constant: -16),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            translateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            translateView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            translateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            translateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            translateView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 24),
            translateView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
