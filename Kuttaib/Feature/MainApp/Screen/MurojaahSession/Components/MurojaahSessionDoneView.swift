//
//  MurojaahSessionDoneView.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit

final class MurojaahSessionDoneView: UIViewController {
    
    private let illustration = UIImageView()
    private let titleLabel = UILabel()
    private let desc = UILabel()
    
    private let previousRecordingView = RecordingOptionView()
    private let newRecordingView = RecordingOptionView()
    
    private let infoIcon = UIImageView()
    private let infoLabel = UILabel()
    private let infoHStack = UIStackView()
    
    private let retryRecord = PrimaryButton(title: "Rekam Ulang")
    private let nextButton = PrimaryButton(title: "Lanjut Ayat Berikutnya")
    
    private let mainVStack = UIStackView()
    
    var ayahNumber: Int
    var buttonType: MurojaahButtonType = .next
    
    var onContinue: ((MurojaahButtonType) -> Void)?
    
    init(ayahNumber: Int) {
        self.ayahNumber = ayahNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAction()
    }
    
    private func setup() {
        illustration.image = UIImage(named: "il-done-record")
        illustration.contentMode = .scaleAspectFit
        illustration.setContentHuggingPriority(.defaultLow, for: .vertical)
        illustration.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Rekaman Ayat \(ayahNumber)"
        
        desc.font = .systemFont(ofSize: 14)
        desc.textColor = .systemGray2
        desc.numberOfLines = 0
        desc.textAlignment = .center
        desc.text = "Dengarkan keduanya, lalu pilih yang ingin kamu simpan."
        
        previousRecordingView.config(.oldRecord, isSelected: true)
        newRecordingView.config(.newRecord, isSelected: false)
        
        infoIcon.image = UIImage(systemName: "info.circle")
        infoIcon.tintColor = .systemGray2
        infoIcon.contentMode = .scaleAspectFit
        
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .systemGray2
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        infoLabel.text = "Satu ayat menyimpan satu rekaman. Rekaman yang tidak dipilih akan dihapus."
        
        [infoIcon, infoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoHStack.addArrangedSubview($0)
        }
        
        infoHStack.axis = .horizontal
        infoHStack.spacing = 8
        infoHStack.alignment = .top
        infoHStack.distribution = .fill
        
        retryRecord.setColor(.systemGray5, titleColor: .primaryGreen)
        
        [illustration, titleLabel, desc, previousRecordingView, newRecordingView, infoHStack, retryRecord, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(8, after: titleLabel)
        mainVStack.setCustomSpacing(16, after: previousRecordingView)
        
        view.addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            infoIcon.heightAnchor.constraint(equalToConstant: 16),
            infoIcon.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        retryRecord.addTarget(self, action: #selector(onRetryRecordTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(onNextButton), for: .touchUpInside)
    }
    
    private func setupAction() {
        previousRecordingView.onSelect = {[weak self] in
            self?.previousRecordingView.isSelectedOption = true
            self?.newRecordingView.isSelectedOption = false
        }
        
        newRecordingView.onSelect = {[weak self] in
            self?.previousRecordingView.isSelectedOption = false
            self?.newRecordingView.isSelectedOption = true
        }
    }
    
    func updateButton(_ type: MurojaahButtonType) {
        buttonType = type
        
        switch type {
        case .done:
            nextButton.updateTitle("Simpan")
        case .next:
            nextButton.updateTitle("Lanjut Ayat Berikutnya")
        }
    }
    
    @objc private func onRetryRecordTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func onNextButton() {
        dismiss(animated: true) {[weak self] in
            guard let self else { return }
            
            // simpan record audio
            
            onContinue?(buttonType)
        }
    }
}

final class RecordingOptionView: UIView {
    private let icon = UIImageView()
    private let title = UILabel()
    private let topHStack = UIStackView()
    
    private let playButton = UIButton(type: .system)
    private let slider = AudioSlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let timeHStack = UIStackView()
    private let sliderVStack = UIStackView()
    private let recordHStack = UIStackView()
    
    private let mainVStack = UIStackView()
    
    var onSelect: (() -> Void)?
    var onPlay: (() -> Void)?
    
    enum RecordType {
        case newRecord
        case oldRecord
    }
    
    var isSelectedOption: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        
        title.font = .systemFont(ofSize: 14, weight: .bold)
        title.textColor = .black
        title.numberOfLines = 0
        
        [icon, title].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.distribution = .fill
        topHStack.alignment = .center
        topHStack.spacing = 8
        
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
        
        [playButton, sliderVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            recordHStack.addArrangedSubview($0)
        }
        
        recordHStack.axis = .horizontal
        recordHStack.spacing = 16
        recordHStack.alignment = .fill
        recordHStack.distribution = .fill
        
        [topHStack, recordHStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.distribution = .fill
        mainVStack.alignment = .fill
        mainVStack.spacing = 16
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.widthAnchor.constraint(equalToConstant: 44),
            
            heightAnchor.constraint(equalToConstant: 120)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        addGestureRecognizer(tapGesture)
    }
    
    func config(_ type: RecordType, isSelected: Bool) {
        switch type {
        case .newRecord:
            title.text = "Ganti dengan rekaman baru"
        case .oldRecord:
            title.text = "Pertahankan rekaman sebelumnya"
        }
        
        isSelectedOption = isSelected
    }
    
    private func updateView() {
        if isSelectedOption {
            layer.borderColor = UIColor.primaryGreen.cgColor
            backgroundColor = .backgroundGreen
            
            icon.image = UIImage(systemName: "circle.inset.filled")
            icon.tintColor = .primaryGreen
        } else {
            layer.borderColor = UIColor.systemGray5.cgColor
            backgroundColor = .white
            
            icon.image = UIImage(systemName: "circle")
            icon.tintColor = .systemGray5
        }
    }
    
    @objc private func didTapCard() {
        onSelect?()
    }

    @objc private func didTapPlay() {
        onPlay?()
    }
}

extension RecordingOptionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self)

        if playButton.frame.contains(location) {
            return false
        }

        return true
    }
}
