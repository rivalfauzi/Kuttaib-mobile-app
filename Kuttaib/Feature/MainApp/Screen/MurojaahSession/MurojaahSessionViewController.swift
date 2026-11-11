//
//  MurojaahSessionViewController.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit
import SkeletonView

final class MurojaahSessionViewController: BaseViewController {
    let presenter: MurojaahSessionPresenter
    
    let stepIndicator = StepIndicatorView()
    let stepIndicatorView = UIView()
    let headerView = HeaderMurojaahSessionView()
    let ayatView = AyatMurojaahSessionView()
    let recordView = RecordMurojaahSessionView()
    let mainButton = PrimaryButton(title: "Tahan untuk Mengintip Ayat")
    let mainVStack = UIStackView()
    
    var stepIndex = 0
    var numberOfAyah = 0
    
    init(presenter: MurojaahSessionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupListener()
        setupAcction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initService()
    }
    
    private func setup() {
        setupNavigationTitle()
        
        let totalTask = (presenter.task.endAyah ?? 0) - (presenter.task.startAyah ?? 0) + 1
        stepIndicator.updateTotalSteps(total: totalTask)
        stepIndicator.update(step: stepIndex)
        stepIndicator.translatesAutoresizingMaskIntoConstraints = false
        stepIndicatorView.addSubview(stepIndicator)
        
        stepIndicatorView.isHidden = totalTask == 1
        
        mainButton.setColor(.systemGray6, titleColor: .primaryGreen)
        
        ayatView.setContentHuggingPriority(.defaultLow, for: .vertical)
        ayatView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        recordView.setContentHuggingPriority(.required, for: .vertical)
        recordView.setContentCompressionResistancePriority(.required, for: .vertical)
        mainButton.setContentHuggingPriority(.required, for: .vertical)
        
        [stepIndicatorView, headerView, ayatView, recordView, mainButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(36, after: recordView)
        
        view.addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stepIndicator.centerXAnchor.constraint(equalTo: stepIndicatorView.centerXAnchor),
            stepIndicator.centerYAnchor.constraint(equalTo: stepIndicatorView.centerYAnchor),
            stepIndicatorView.heightAnchor.constraint(equalToConstant: 8),
        ])
        
        if case .done = presenter.task.status {
            stepIndex = (presenter.task.completedEndAyah ?? 0) - 1
        } else {
            stepIndex = presenter.task.completedEndAyah ?? 0
        }
        
        stepIndicator.update(step: stepIndex)
        
        mainButton.addTarget(self, action: #selector(peekStarted), for: .touchDown)
        mainButton.addTarget(self, action: #selector(peekEnded), for: .touchUpInside)
        mainButton.addTarget(self, action: #selector(peekEnded), for: .touchUpOutside)
        mainButton.addTarget(self, action: #selector(peekEnded), for: .touchCancel)
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Murojaah"
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
    }
    
    private func setupListener() {
        presenter.onGetActiveTarget = {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.target = response
                updateHeaderView()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        presenter.onGetAyah = {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard let startAyah = presenter.task.startAyah, let endAyah = presenter.task.endAyah, let surahNumber = presenter.surah?.number, !response.isEmpty else { return }
                
                let ayahs = response.filter {
                    $0.surah.number == surahNumber &&
                    $0.numberInSurah >= startAyah &&
                    $0.numberInSurah <= endAyah
                }
                
                presenter.ayahs = ayahs
                updateAyatView()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        presenter.onDone = {
            print("Done")
        }
    }
    
    private func setupAcction() {
        recordView.onSaveRecord = {[weak self] in
            guard let self else { return }
            
            let vc = MurojaahSessionDoneView(ayahNumber: numberOfAyah)
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [
                    .large()
                ]
                
                sheet.prefersGrabberVisible = true
            }
            
            vc.onContinue = { buttonType in
                self.murojaahSessionDoneTap(buttonType)
            }
            
            guard let startAyah = presenter.task.startAyah, let endAyah = presenter.task.endAyah else { return }
            
            if (startAyah + stepIndex) >= endAyah {
                vc.updateButton(.done)
            } else {
                vc.updateButton(.next)
            }
            
            present(vc, animated: true)
        }
    }
    
    private func murojaahSessionDoneTap(_ buttonType: MurojaahButtonType) {
        presenter.saveMurojaahTask {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.task = response
                
                if case .done = buttonType {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    stepIndex += 1
                    updateHeaderView()
                    updateAyatView()
                    stepIndicator.update(step: stepIndex)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func updateHeaderView() {
        guard let startAyah = presenter.task.startAyah, let tasks = presenter.target?.tasks else { return }
        
        let ayah = startAyah + stepIndex
        numberOfAyah = ayah
        let repetition = presenter.repetitionCount(for: ayah, tasks: tasks)
        
        headerView.configure(number: ayah, count: repetition)
    }
    
    private func updateAyatView() {
        guard !presenter.ayahs.isEmpty else { return }
        
        let ayah = presenter.ayahs[stepIndex]
        let repetition = presenter.repetitionCount(for: ayah.numberInSurah, tasks: presenter.target?.tasks ?? [])
        var arabic = ayah.text
        
        if ayah.number != 1, ayah.numberInSurah == 1 {
            arabic = arabic.replacingOccurrences(
                of: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                with: ""
            )
        }
        
        ayatView.configure(arabic, repetition: repetition)
    }
    
    @objc private func peekStarted() {
        ayatView.showAyah()
    }

    @objc private func peekEnded() {
        ayatView.hideAyah()
    }
}
