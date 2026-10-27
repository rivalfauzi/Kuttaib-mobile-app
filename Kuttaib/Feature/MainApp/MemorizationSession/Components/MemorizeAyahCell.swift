//
//  MemorizeAyahCell.swift
//  Kuttaib
//
//  Created by mco on 27/10/26.
//

import UIKit

final class MemorizeAyahCell: UICollectionViewCell {

    static let reuseIdentifier = "MemorizeAyahCell"

    private let scrollView = UIScrollView()
    private let containerView = UIView()

    let ayahView = MemorizeAyahSections()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {

        [scrollView, containerView, ayahView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(ayahView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            ayahView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            ayahView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            ayahView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ayahView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            ayahView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(
        arabic: String,
        latin: String,
        translate: String
    ) {
        ayahView.setText(
            arabic: arabic,
            latin: latin,
            translate: translate
        )
    }
}
