//
//  RecordMicButton.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//


import UIKit

final class RecordMicButton: UIButton {

    // MARK: - Public
    private(set) var isRecording = false

    var onRecordingChanged: ((Bool) -> Void)?

    // MARK: - Views
    private let outerCircle = UIView()
    private let middleCircle = UIView()
    private let centerCircle = UIView()
    private let iconImageView = UIImageView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 140, height: 140)
    }

    // MARK: - Setup
    private func setup() {

        translatesAutoresizingMaskIntoConstraints = false

        [outerCircle, middleCircle, centerCircle, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
        }

        addSubview(outerCircle)
        addSubview(middleCircle)
        addSubview(centerCircle)
        centerCircle.addSubview(iconImageView)

        outerCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.12)
        middleCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.25)
        centerCircle.backgroundColor = .primaryGreen

        iconImageView.image = UIImage(systemName: "mic.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([

            widthAnchor.constraint(equalToConstant: 120),
            heightAnchor.constraint(equalToConstant: 120),

            outerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 120),
            outerCircle.heightAnchor.constraint(equalToConstant: 120),

            middleCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleCircle.widthAnchor.constraint(equalToConstant: 92),
            middleCircle.heightAnchor.constraint(equalToConstant: 92),

            centerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerCircle.widthAnchor.constraint(equalToConstant: 68),
            centerCircle.heightAnchor.constraint(equalToConstant: 68),

            iconImageView.centerXAnchor.constraint(equalTo: centerCircle.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerCircle.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        outerCircle.layer.cornerRadius = 60
        middleCircle.layer.cornerRadius = 46
        centerCircle.layer.cornerRadius = 34
    }

    // MARK: - Action
    @objc private func buttonTapped() {
        isRecording.toggle()
        updateAppearance()
        onRecordingChanged?(isRecording)
    }

    // MARK: - UI
    private func updateAppearance() {
        if isRecording {
            outerCircle.backgroundColor = .primaryRed.withAlphaComponent(0.12)
            middleCircle.backgroundColor = .primaryRed.withAlphaComponent(0.25)
            centerCircle.backgroundColor = .primaryRed
            iconImageView.image = UIImage(systemName: "stop.fill")

            startPulse()
        } else {
            outerCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.12)
            middleCircle.backgroundColor = .primaryGreen.withAlphaComponent(0.25)
            centerCircle.backgroundColor = .primaryGreen
            iconImageView.image = UIImage(systemName: "mic.fill")

            stopPulse()
        }
    }

    // MARK: - Pulse Animation
    private func startPulse() {

        guard outerCircle.layer.animation(forKey: "pulse") == nil else {
            return
        }

        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.fromValue = 1.0
        animation.toValue = 1.12
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity

        outerCircle.layer.add(animation, forKey: "pulse")
    }

    private func stopPulse() {

        outerCircle.layer.removeAnimation(forKey: "pulse")
    }
}
