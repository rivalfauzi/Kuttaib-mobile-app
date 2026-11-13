//
//  TargetCompletedView.swift
//  Kuttaib
//
//  Created by mco on 11/11/26.
//

import UIKit

final class TargetCompletedView: UIViewController {

    var onContinue: (() -> Void)?
    var onFinish: (() -> Void)?

    private let dimView = UIView()
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let numberLabel = UILabel()
    private let numberBackground = UIView()
    private let badgeTitleLabel = UILabel()
    private let badgeSurahLabel = UILabel()
    private let badgeAyatNumberLabel = UILabel()
    private let badgeRightVStack = UIStackView()
    private let badgeHStackView = UIStackView()
    private let badgeView = UIView()
    
    private let notes = UILabel()
    private let continueButton = PrimaryButton(title: "Lanjut")
    private let finishButton = UIButton()
    
    private let mainVStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        view.addSubview(dimView)
        view.addSubview(containerView)

        dimView.frame = view.bounds
        containerView.backgroundColor = .warmBackground
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(named: "il-done-target")
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.text = "Alhamdulillah!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .systemGray2
        
        numberLabel.font = .systemFont(ofSize: 17, weight: .bold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numberBackground.addSubview(numberLabel)
        numberBackground.backgroundColor = .primaryGreen
        numberBackground.layer.cornerRadius = 12
        
        badgeTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        badgeTitleLabel.textColor = .primaryGreen
        badgeTitleLabel.textAlignment = .left
        badgeTitleLabel.text = "SURAH BERIKUTNYA"
        
        badgeSurahLabel.font = .systemFont(ofSize: 17, weight: .bold)
        badgeSurahLabel.textColor = .black
        badgeSurahLabel.textAlignment = .left
        
        badgeAyatNumberLabel.font = .systemFont(ofSize: 13)
        badgeAyatNumberLabel.textColor = .systemGray2
        badgeAyatNumberLabel.textAlignment = .left
        
        [badgeTitleLabel, badgeSurahLabel, badgeAyatNumberLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            badgeRightVStack.addArrangedSubview($0)
        }
        
        badgeRightVStack.axis = .vertical
        badgeRightVStack.spacing = 4
        badgeRightVStack.alignment = .fill
        badgeRightVStack.distribution = .fill
        
        [numberBackground, badgeRightVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            badgeHStackView.addArrangedSubview($0)
        }
        
        badgeHStackView.axis = .horizontal
        badgeHStackView.spacing = 16
        badgeHStackView.alignment = .center
        badgeHStackView.distribution = .fill
        badgeHStackView.translatesAutoresizingMaskIntoConstraints = false
        
        badgeView.addSubview(badgeHStackView)
        badgeView.backgroundColor = .backgroundGreen.withAlphaComponent(0.4)
        badgeView.layer.cornerRadius = 24
        
        notes.font = .systemFont(ofSize: 13)
        notes.numberOfLines = 0
        notes.textAlignment = .center
        notes.textColor = .systemGray2
        
        finishButton.setTitleColor(.primaryGreen, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [iconView, titleLabel, descriptionLabel, badgeView, notes, continueButton, finishButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(16, after: titleLabel)
        mainVStack.setCustomSpacing(16, after: descriptionLabel)
        mainVStack.setCustomSpacing(16, after: badgeView)
        
        containerView.addSubview(mainVStack)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            iconView.widthAnchor.constraint(equalToConstant: 150),
            iconView.heightAnchor.constraint(equalToConstant: 150),
            
            numberBackground.heightAnchor.constraint(equalToConstant: 44),
            numberBackground.widthAnchor.constraint(equalToConstant: 44),
            numberLabel.centerXAnchor.constraint(equalTo: numberBackground.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberBackground.centerYAnchor),
            
            badgeHStackView.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 8),
            badgeHStackView.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 24),
            badgeHStackView.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -24),
            badgeHStackView.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -8),
            
            mainVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
        ])
    }
    
    func setupAction() {
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
    }
    
    func setData(previous: Quran.Surah.Response, next: Quran.Surah.Response, userDailyTarget: Int) {
        descriptionLabel.text = "Kamu telah menyelesaikan hafalan Surah \(previous.englishName) (\(previous.numberOfAyahs) ayat)."
        
        numberLabel.text = "\(next.number)"
        badgeSurahLabel.text = next.englishName
        badgeAyatNumberLabel.text = "\(next.numberOfAyahs) ayat"
        finishButton.setTitle("Pilih Nanti Saja", for: .normal)
        
        let estimated = (next.numberOfAyahs + userDailyTarget - 1) / userDailyTarget
        notes.text = "Estimasi selesai ± \(estimated) hari dengan \(userDailyTarget) ayat per hari"
    }
    
    func hideNextSession(previous: Quran.Surah.Response) {
        descriptionLabel.text = "Kamu telah menyelesaikan hafalan Surah \(previous.englishName) (\(previous.numberOfAyahs) ayat)."
        badgeView.isHidden = true
        continueButton.isHidden = true
        notes.isHidden = true
        finishButton.setTitle("Kembali", for: .normal)
    }

    @objc func continueTapped() {
        dismiss(animated: false)
        onContinue?()
    }

    @objc func finishTapped() {
        dismiss(animated: false)
        onFinish?()
    }
    
    func showAnimation() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
}
