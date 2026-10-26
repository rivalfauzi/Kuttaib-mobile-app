//
//  SoundPlayCard.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class SoundPlayCard: UIView {
    private let playButton = UIButton(type: .system)
    private let slider = AudioSlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let timeHStack = UIStackView()
    private let sliderVStack = UIStackView()
    private let speedStackView = UIStackView()
    
    private let rates: [Float] = [0.75, 1.0, 1.25, 1.5]
    private var selectedRate: Float = 1.0
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        backgroundColor = .primaryGreen.withAlphaComponent(0.1)
        layer.cornerRadius = 16
        
        playButton.setImage(
            UIImage(systemName: "play.fill"),
            for: .normal
        )
        playButton.backgroundColor = .primaryGreen
        playButton.tintColor = .white
        playButton.layer.cornerRadius = 22
        
        currentTimeLabel.text = "00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .systemGray
        
        durationLabel.text = "00:08"
        durationLabel.font = .systemFont(ofSize: 12)
        durationLabel.textColor = .systemGray
        
        [currentTimeLabel, UIView(), durationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            timeHStack.addArrangedSubview($0)
        }
        
        timeHStack.axis = .horizontal
        timeHStack.spacing = 4
        timeHStack.alignment = .fill
        timeHStack.distribution = .fill
        
        slider.minimumTrackTintColor = .primaryGreen
        slider.makeThumbImage(diameter: 14, color: .primaryGreen)
        slider.isUserInteractionEnabled = false
        
        [slider, timeHStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            sliderVStack.addArrangedSubview($0)
        }
        
        sliderVStack.axis = .vertical
        sliderVStack.spacing = 4
        sliderVStack.alignment = .fill
        sliderVStack.distribution = .fill
        
        let audioStack = UIStackView(arrangedSubviews: [
            playButton,
            sliderVStack
        ])
        
        audioStack.axis = .horizontal
        audioStack.spacing = 16
        audioStack.alignment = .center
        
        rates.forEach { rate in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 18
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            let isSelected = rate == selectedRate
            button.backgroundColor = isSelected ? .primaryGreen : .systemGray6
            button.setTitleColor(isSelected ? .white : .systemGray, for: .normal)
            
            button.setTitle("\(rate)x", for: .normal)
            button.tag = buttons.count
            button.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
            buttons.append(button)
            
            speedStackView.addArrangedSubview(button)
        }
        
        speedStackView.axis = .horizontal
        speedStackView.spacing = 8
        speedStackView.distribution = .fillEqually
        
        [audioStack, speedStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            audioStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            audioStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            audioStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            speedStackView.topAnchor.constraint(equalTo: audioStack.bottomAnchor, constant: 12),
            speedStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            speedStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            speedStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.widthAnchor.constraint(equalToConstant: 44),
            slider.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func updateButtons() {
        for (index, button) in buttons.enumerated() {
            let rate = rates[index]
            let isSelected = rate == selectedRate
            button.backgroundColor = isSelected ? .primaryGreen : .systemGray6

            button.setTitleColor(
                isSelected ? .white : .systemGray,
                for: .normal
            )
        }
    }
    
    @objc private func rateTapped(_ sender: UIButton) {
        let rate = rates[sender.tag]
        selectedRate = rate
        updateButtons()
    }
    
}
