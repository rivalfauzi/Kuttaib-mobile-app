//
//  MemorizationViewController.swift
//  Kuttaib
//
//  Created by mco on 26/10/26.
//

import UIKit

final class MemorizationViewController: BaseViewController {
    let presenter: MemorizationPresenter
    
    let subtitleLabel = UILabel()
    
    let stepIndicator = StepIndicatorView()
    let stepIndicatorView = UIView()
    let topSpacer = UIView()
    let bottomSpacer = UIView()
    
    // learn type
    lazy var learnCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let soundCard = SoundPlayCard()
    let nextButton = PrimaryButton(title: "Mulai Menghafal")
    let skipButton = UIButton()
    
    // record type
    let recordHideTitle = UILabel()
    let recordHideSubtitle = UILabel()
    let recordHideVStackView = UIStackView()
    let recordHideView = UIView()
    let micButton = RecordMicButton()
    let micLabelDesc = UILabel()
    let showAyahButton = PrimaryButton(title: "Tampilkan Ayat")
    
    // done type
    let doneIcon = UIImageView()
    let doneTitle = UILabel()
    let doneDesc = UILabel()
    let doneVStack = UIStackView()
    
    let mainVStack = UIStackView()
    
    let alertCompleted = TaskCompletedViewController()
    
    var stepIndex = 0
    private var recordingTimer: Timer?
    private var recordingSeconds = 0
    
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
        recordHideSubtitle.text = "Cobalah hafalkan dengan suaramu."
        
        micLabelDesc.font = .systemFont(ofSize: 14)
        micLabelDesc.textColor = .systemGray
        micLabelDesc.textAlignment = .center
        micLabelDesc.numberOfLines = 0
        micLabelDesc.text = "Tekan tombol untuk mulai merekam."
        
        [recordHideTitle, recordHideSubtitle, micButton, micLabelDesc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            recordHideVStackView.addArrangedSubview($0)
        }
        
        recordHideVStackView.axis = .vertical
        recordHideVStackView.spacing = 24
        recordHideVStackView.alignment = .center
        recordHideVStackView.distribution = .fill
        recordHideVStackView.translatesAutoresizingMaskIntoConstraints = false
        recordHideVStackView.setCustomSpacing(12, after: recordHideTitle)
        
        recordHideView.addSubview(recordHideVStackView)
        
        showAyahButton.setColor(.systemGray5, titleColor: .secondaryGreen)
        skipButton.setTitle("Sudah Hafal", for: .normal)
        skipButton.setTitleColor(.primaryGreen, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        learnCollectionView.delegate = self
        learnCollectionView.dataSource = self
        learnCollectionView.backgroundColor = .clear

        learnCollectionView.register(
            MemorizeAyahCell.self,
            forCellWithReuseIdentifier: MemorizeAyahCell.reuseIdentifier
        )
        
        doneTitle.font = .systemFont(ofSize: 24, weight: .bold)
        doneTitle.textColor = .black
        doneTitle.textAlignment = .center
        doneTitle.numberOfLines = 0
        doneTitle.text = "Rekaman Selesai"
        
        doneDesc.font = .systemFont(ofSize: 16)
        doneDesc.textColor = .systemGray
        doneDesc.textAlignment = .center
        doneDesc.numberOfLines = 0
        doneDesc.text = "Dengarkan kembali bacaanmu sebelum lanjut ke ayat berikutnya."
        
        doneIcon.image = UIImage(named: "il-done-record")
        doneIcon.contentMode = .scaleAspectFit
        doneIcon.clipsToBounds = true
        
        [doneIcon, doneTitle, doneDesc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            doneVStack.addArrangedSubview($0)
        }
        
        doneVStack.axis = .vertical
        doneVStack.spacing = 16
        doneVStack.alignment = .center
        doneVStack.distribution = .fill
        
        [stepIndicatorView, topSpacer, learnCollectionView, recordHideView, doneVStack, bottomSpacer, soundCard, showAyahButton, nextButton, skipButton].forEach {
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
            
            learnCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            doneIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
        ])
        
        setupConditionalView()
        setupAlertView()
        
        nextButton.addTarget(self, action: #selector(startMemorizeTapped), for: .touchUpInside)
        micButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        showAyahButton.addTarget(self, action: #selector(showAyahButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(nextAyah), for: .touchUpInside)
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = presenter.task.type?.rawValue.capitalized
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center

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
    
    private func setupService() {
        presenter.fetch {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.allOfAyah = response
                presenter.getAyahsTask()
                
                if case .done = presenter.task.status {
                    stepIndex = (presenter.task.completedEndAyah ?? 0) - 1
                } else {
                    stepIndex = presenter.task.completedEndAyah ?? 0
                }
                
                stepIndicator.update(step: stepIndex)
                reloadCollectionView()
                
                let indexPath = IndexPath(item: stepIndex, section: 0)
                learnCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
                updateView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupConditionalView() {
        switch presenter.viewState {
        case .learn:
            soundCard.isHidden = false
            soundCard.hideSpeedStackView(false)
            nextButton.isHidden = false
            skipButton.isHidden = false
            skipButton.setTitle("Sudah Hafal", for: .normal)
            learnCollectionView.isHidden = false
            
            recordHideView.isHidden = true
            micButton.isHidden = true
            showAyahButton.isHidden = true
            doneVStack.isHidden = true
        case .record:
            soundCard.isHidden = true
            nextButton.isHidden = true
            skipButton.isHidden = false
            skipButton.setTitle("Kembali", for: .normal)
            skipButton.setColorEnable(true)
            learnCollectionView.isHidden = true
            
            recordHideView.isHidden = false
            micButton.isHidden = false
            showAyahButton.isHidden = false
            showAyahButton.updateTitle("Tampilkan Ayat")
            
            recordHideTitle.text = "Ayat \(presenter.ayahs[stepIndex].numberInSurah)"
            recordHideTitle.textColor = .black
            recordHideSubtitle.text = "Cobalah hafalkan dengan suaramu."
            micLabelDesc.text = "Tekan tombol untuk mulai merekam."
            
            doneVStack.isHidden = true
        case .done:
            soundCard.isHidden = false
            soundCard.hideSpeedStackView(true)
            nextButton.isHidden = false
            
            if let completedEndAyah = presenter.task.completedEndAyah, stepIndex < completedEndAyah {
                nextButton.updateTitle("Simpan Perubahan")
            } else {
                nextButton.updateTitle("Lanjut ke Ayat Berikutnya")
            }
            
            skipButton.isHidden = true
            learnCollectionView.isHidden = true
            
            recordHideView.isHidden = true
            micButton.isHidden = true
            showAyahButton.isHidden = false
            showAyahButton.updateTitle("Rekam Ulang")
            doneVStack.isHidden = false
        }
    }
    
    private func updateView() {
        guard let completedEndAyah = presenter.task.completedEndAyah, let status = presenter.task.status else { return }
        skipButton.setTitle("Sudah Hafal", for: .normal)
        
        if stepIndex == completedEndAyah {
            nextButton.updateTitle("Mulai Menghafal")
            nextButton.isEnabled = true
            skipButton.setColorEnable(true)
        } else if (stepIndex + 1) == completedEndAyah, case .done = status {
            nextButton.updateTitle("Ulang Hafalan")
            nextButton.isEnabled = true
            skipButton.setColorEnable(true)
            skipButton.setTitle("Lanjut ke Ayat Berikutnya", for: .normal)
        } else if stepIndex < completedEndAyah {
            nextButton.updateTitle("Ulang Hafalan")
            nextButton.isEnabled = true
            skipButton.setColorEnable(false)
        } else {
            nextButton.isEnabled = false
            skipButton.setColorEnable(false)
        }
    }
    
    private func swipeView() {
        guard stepIndex + 1 < presenter.ayahs.count else {
            return
        }
        
        stepIndex += 1
        stepIndicator.update(step: stepIndex)
        let indexPath = IndexPath(item: stepIndex, section: 0)
        learnCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        updateView()
    }
    
    private func setupAlertView() {
        alertCompleted.modalPresentationStyle = .overCurrentContext
        alertCompleted.modalTransitionStyle = .crossDissolve
        
        alertCompleted.onContinue = {[weak self] in
            self?.updateEndTask()
        }
        
        alertCompleted.onFinish = { [weak self] in
            guard let self else { return }
            presenter.finishTask { result in
                switch result {
                case .success(_):
                    self.presenter.navigateToRootView()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func reloadCollectionView() {
        learnCollectionView.reloadData()
        learnCollectionView.layoutIfNeeded()
    }
    
    private func updateEndTask() {
        presenter.addTaskTarget { result in
            switch result {
            case .success(let response):
                self.presenter.task = response
                let totalTask = (response.endAyah ?? 0) - (response.startAyah ?? 0) + 1
                self.stepIndicator.updateTotalSteps(total: totalTask)
                self.presenter.getAyahsTask()
                self.reloadCollectionView()
                self.subtitleLabel.text = "\(self.presenter.surah?.englishName ?? "") \(response.startAyah ?? 0) - \(response.endAyah ?? 0)"
                
                self.presenter.viewState = .learn
                self.setupConditionalView()
                self.swipeView()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    @objc private func notificationTapped() {
        
    }
    
    @objc private func nextAyah() {
        switch presenter.viewState {
        case .learn:
            guard let status = presenter.task.status else { return }
            
            if case .done = status {
                updateEndTask()
            } else {
                presenter.saveTaskUpdate(taskCompleted: (stepIndex + 1)) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let response):
                        presenter.task = response
                        
                        if response.lastCompletedAyah == response.endAyah {
                            present(alertCompleted, animated: false)
                        } else {
                            swipeView()
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        case .record:
            presenter.viewState = .learn
            setupConditionalView()
            updateView()
        case .done:
            break
        }
    }
    
    @objc private func startMemorizeTapped() {
        switch presenter.viewState {
        case .learn:
            presenter.viewState = .record
            setupConditionalView()
        case .record:
            break
        case .done:
            presenter.saveTaskUpdate(taskCompleted: (stepIndex + 1)) {[weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    if response.lastCompletedAyah == response.endAyah {
                        presenter.task = response
                        present(alertCompleted, animated: false)
                    } else {
                        presenter.viewState = .learn
                        setupConditionalView()
                        
                        if let completedEndAyah = presenter.task.completedEndAyah,
                            stepIndex == completedEndAyah {
                            presenter.task = response
                            swipeView()
                        } else {
                            presenter.task = response
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    @objc private func recordTapped() {
        if micButton.isRecording {
            recordHideTitle.text = "Sedang Merekam"
            recordHideTitle.textColor = .primaryRed
            recordHideSubtitle.text = "00:00"
            startRecordingTimer()
            micLabelDesc.text = "Bacakan ayat dengan jelas."
            
            print("Start Recording")
        } else {
            stopRecordingTimer()
            presenter.viewState = .done
            setupConditionalView()
            
            print("Stop Recording")
        }
    }
    
    private func startRecordingTimer() {
        recordingSeconds = 0
        updateTimerLabel()

        recordingTimer?.invalidate()

        recordingTimer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.recordingSeconds += 1
            self.updateTimerLabel()
        }
    }
    
    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    private func updateTimerLabel() {
        let minutes = recordingSeconds / 60
        let seconds = recordingSeconds % 60
        recordHideSubtitle.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc private func showAyahButtonTapped() {
        switch presenter.viewState {
        case .learn:
            break
        case .record:
            let ayah = presenter.ayahs[stepIndex]
            var arabic = ayah.text
            
            if ayah.number != 1, ayah.numberInSurah == 1 {
                arabic = arabic.replacingOccurrences(
                    of: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                    with: ""
                )
            }
            
            let vc = AyahBottomSheetViewController(
                title: "Ayat \(ayah.numberInSurah)",
                arabic: arabic,
                latin: "Wa ja'alna nahara ma'asha",
                translation: "Dan kami menjadikan siang untuk mencari penghidupan."
            )
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [
                    .medium(),
                    .large()
                ]
                
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.selectedDetentIdentifier = .medium
            }
            
            present(vc, animated: true)
        case .done:
            presenter.viewState = .record
            setupConditionalView()
        }
    }
}

extension MemorizationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.ayahs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemorizeAyahCell.reuseIdentifier, for: indexPath) as! MemorizeAyahCell
        
        let ayah = presenter.ayahs[indexPath.item]
        var arabic = ayah.text
        
        if ayah.number != 1, ayah.numberInSurah == 1 {
            arabic = arabic.replacingOccurrences(
                of: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                with: ""
            )
        }
        
        cell.configure(
            arabic: arabic,
            latin: "Wa ja'alna nahara ma'asha",
            translate: "Dan kami menjadikan siang untuk mencari penghidupan."
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == learnCollectionView else { return }
        
        stepIndex = Int(
            round(
                scrollView.contentOffset.x /
                scrollView.bounds.width
            )
        )
        
        stepIndicator.update(step: stepIndex)
        updateView()
    }
}

