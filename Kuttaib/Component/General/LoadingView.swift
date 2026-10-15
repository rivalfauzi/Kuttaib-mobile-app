//
//  LoadingView.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import UIKit

final class LoadingView: UIView {

    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.black.withAlphaComponent(0.3)

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
