//
//  SnackbarView.swift
//  Kuttaib
//
//  Created by mco on 20/11/26.
//

import UIKit

final class SnackbarView: UIView {

    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()

    init(type: SnackbarType, message: String) {
        super.init(frame: .zero)

        backgroundColor = type.backgroundColor
        layer.cornerRadius = 12
        clipsToBounds = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        iconImageView.image = type.icon
        iconImageView.tintColor = type.tintColor
        iconImageView.contentMode = .scaleAspectFit

        messageLabel.text = message
        messageLabel.textColor = type.tintColor
        messageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        messageLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [
            iconImageView,
            messageLabel
        ])

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
