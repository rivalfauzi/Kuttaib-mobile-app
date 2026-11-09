//
//  LineProgressView.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//


import UIKit

final class LineProgressView: UIView {

    private let trackView = UIView()
    private let progressView = UIView()

    private var progressWidthConstraint: NSLayoutConstraint!

    var progress: CGFloat = 0 {
        didSet {
            updateProgress(animated: true)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        trackView.backgroundColor = .systemGray5
        trackView.layer.cornerRadius = 5

        progressView.backgroundColor = .primaryGreen
        progressView.layer.cornerRadius = 5

        addSubview(trackView)
        trackView.addSubview(progressView)

        trackView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackView.topAnchor.constraint(equalTo: topAnchor),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            trackView.heightAnchor.constraint(equalToConstant: 10),

            progressView.topAnchor.constraint(equalTo: trackView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            progressView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor)
        ])

        progressWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgress(animated: false)
    }

    private func updateProgress(animated: Bool) {

        let width = trackView.bounds.width * progress

        progressWidthConstraint.constant = width

        guard animated else { return }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
