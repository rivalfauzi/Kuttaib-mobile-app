//
//  MemorizationViewController.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class MemorizationViewController: BaseViewController {
    let presenter: MemorizationPresenter
    
    let stepIndicator = StepIndicatorView()
    let stepIndicatorView = UIView()
    let topSpacer = UIView()
    let translateView = MemorizeAyahSections()
    let bottomSpacer = UIView()
    
    // learn type
    let soundCard = SoundPlayCard()
    let nextButton = PrimaryButton(title: "Mulai Menghafal")
    
    // record type
    let recordHideTitle = UILabel()
    let recordHideSubtitle = UILabel()
    let recordHideVStackView = UIStackView()
    let recordHideView = UIView()
    let micButton = RecordMicButton()
    let showAyahButton = PrimaryButton(title: "Tampilkan Ayat")
    
    let mainVStack = UIStackView()
    
    var stepIndex = 0
    var showAyah = false
    
    init(presenter: MemorizationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupService()
    }
    
    private func setup() {
        setupNavigationTitle()
        
        let totalTask = (presenter.task.endAyah ?? 0) - (presenter.task.startAyah ?? 0) + 1
        stepIndicator.updateTotalSteps(total: totalTask)
        stepIndicator.update(step: stepIndex)
        stepIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        stepIndicatorView.addSubview(stepIndicator)
        
        recordHideTitle.font = .systemFont(ofSize: 18, weight: .bold)
        recordHideTitle.textColor = .black
        recordHideTitle.textAlignment = .center
        recordHideTitle.numberOfLines = 0
        
        recordHideSubtitle.font = .systemFont(ofSize: 14)
        recordHideSubtitle.textColor = .systemGray
        recordHideSubtitle.textAlignment = .center
        recordHideSubtitle.numberOfLines = 0
        recordHideSubtitle.text = "Cobalah hafalkan ayat ini dengan suaramu."
        
        [recordHideTitle, recordHideSubtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            recordHideVStackView.addArrangedSubview($0)
        }
        
        recordHideVStackView.axis = .vertical
        recordHideVStackView.spacing = 16
        recordHideVStackView.alignment = .center
        recordHideVStackView.distribution = .fill
        recordHideVStackView.translatesAutoresizingMaskIntoConstraints = false
        
        recordHideView.addSubview(recordHideVStackView)
        
        setupTranslateView(false)
        micButton.isHidden = true
        showAyahButton.isHidden = true
        
        showAyahButton.setColor(.systemGray5, titleColor: .secondaryGreen)
        
        [stepIndicatorView, topSpacer, translateView, recordHideView, micButton, bottomSpacer, soundCard, showAyahButton, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        topSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        bottomSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        
        [mainVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stepIndicator.centerXAnchor.constraint(equalTo: stepIndicatorView.centerXAnchor),
            stepIndicator.centerYAnchor.constraint(equalTo: stepIndicatorView.centerYAnchor),
            stepIndicatorView.heightAnchor.constraint(equalToConstant: 8),
            
            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor),
            
            recordHideVStackView.topAnchor.constraint(equalTo: recordHideView.topAnchor),
            recordHideVStackView.leadingAnchor.constraint(equalTo: recordHideView.leadingAnchor),
            recordHideVStackView.trailingAnchor.constraint(equalTo: recordHideView.trailingAnchor),
            recordHideVStackView.bottomAnchor.constraint(equalTo: recordHideView.bottomAnchor),
        ])
        
        nextButton.addTarget(self, action: #selector(startMemorizeTapped), for: .touchUpInside)
        micButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = presenter.task.type?.rawValue.capitalized
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(presenter.surah?.englishName ?? "") \(presenter.task.startAyah ?? 0) - \(presenter.task.endAyah ?? 0)"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4

        navigationItem.titleView = stackView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: self,
            action: #selector(notificationTapped)
        )
    }
    
    private func updateViewData() {
        stepIndicator.update(step: stepIndex)
        
        if stepIndex < presenter.ayahs.count {
            let data = presenter.ayahs[stepIndex]
            var arabic = data.text
            
            if data.number != 1, data.numberInSurah == 1 {
                arabic = arabic.replacingOccurrences(
                    of: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                    with: ""
                )
            }
            
            translateView.setText(
                arabic: arabic,
                latin: "Wa ja'alna nahara ma'asha",
                translate: "Dan kami menjadikan siang untuk mencari penghidupan."
            )
        }
    }
    
    private func setupService() {
        presenter.fetch {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.getAyahsTask(response)
                stepIndex = presenter.task.completedEndAyah ?? 0
                updateViewData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupConditionalView() {
        soundCard.isHidden = true
        nextButton.isHidden = true
        
        micButton.isHidden = false
        showAyahButton.isHidden = false
        
        nextButton.updateTitle("Ayat Selanjutnya")
        recordHideTitle.text = "Ayat \(presenter.ayahs[stepIndex].numberInSurah)"
    }
    
    private func setupTranslateView(_ hide: Bool) {
        translateView.isHidden = hide
        recordHideView.isHidden = !hide
    }
    
    @objc private func notificationTapped() {
        stepIndex += 1
        updateViewData()
    }
    
    @objc private func startMemorizeTapped() {
        if presenter.viewState == .learn {
            presenter.viewState = .record
            setupConditionalView()
            setupTranslateView(true)
        } else {
            
        }
    }
    
    @objc private func recordTapped() {
        print("Start Recording")
    }
    
}

