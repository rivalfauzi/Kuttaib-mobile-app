//
//  RecordMicButton.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//


import UIKit

final class RecordMicButton: UIControl {

    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let centerButton = UIView()

    private let micImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {

        translatesAutoresizingMaskIntoConstraints = false

        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        middleCircle.translatesAutoresizingMaskIntoConstraints = false
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        micImageView.translatesAutoresizingMaskIntoConstraints = false

        // Outer
        outerCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.12)
        outerCircle.layer.cornerRadius = 70

        // Middle
        middleCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.3)
        middleCircle.layer.cornerRadius = 56

        // Center
        centerButton.backgroundColor = .primaryGreen
        centerButton.layer.cornerRadius = 44

        micImageView.image = UIImage(systemName: "mic.fill")
        micImageView.tintColor = .white
        micImageView.contentMode = .scaleAspectFit

        addSubview(outerCircle)
        addSubview(middleCircle)
        addSubview(centerButton)

        centerButton.addSubview(micImageView)

        NSLayoutConstraint.activate([

            widthAnchor.constraint(equalToConstant: 140),
            heightAnchor.constraint(equalToConstant: 140),

            outerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 140),
            outerCircle.heightAnchor.constraint(equalToConstant: 140),

            middleCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleCircle.widthAnchor.constraint(equalToConstant: 112),
            middleCircle.heightAnchor.constraint(equalToConstant: 112),

            centerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerButton.widthAnchor.constraint(equalToConstant: 88),
            centerButton.heightAnchor.constraint(equalToConstant: 88),

            micImageView.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor),
            micImageView.centerYAnchor.constraint(equalTo: centerButton.centerYAnchor),
            micImageView.widthAnchor.constraint(equalToConstant: 36),
            micImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    override var isHighlighted: Bool {
        didSet {

            UIView.animate(withDuration: 0.15) {
                self.centerButton.transform =
                    self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.95, y: 0.95)
                    : .identity
            }
        }
    }
}
