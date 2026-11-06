//
//  ProfileViewController.swift
//  Kuttaib
//
//  Created by mco on 21/10/26.
//

import UIKit
import SkeletonView

final class ProfileViewController: BaseViewController {
    let presenter: ProfilePresenter
    
    private let titleScreen = UILabel()
    private let usernameCard = UsernameCard()
    private let statisticCard = ProfileStatisticCard()
    private let targetCard = ProfileTargetCard()
    private let reminderCard = ReminderCard()
    
    private let mainVStack = UIStackView()
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    
    private let renameBottomSheet = RenameProfileViewController()
    private let targetBottomSheet = ProfileTargetPopupViewController()
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAction()
        listener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        initService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainVStack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleScreen.text = "Pengaturan"
        titleScreen.font = .systemFont(ofSize: 28, weight: .bold)
        titleScreen.textColor = .black
        titleScreen.textAlignment = .left
        
        usernameCard.isSkeletonable = true
        usernameCard.skeletonCornerRadius = 24
        
        [titleScreen, usernameCard, statisticCard, targetCard, reminderCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.isSkeletonable = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupAction() {
        usernameCard.onTappedChangeButton = {[weak self] in
            guard let self, let presentation = renameBottomSheet.sheetPresentationController else { return }
            
            presentation.detents = [
                .percentage(identifier: .normal, value: 0.35)
            ]
            
            presentation.prefersGrabberVisible = true
            presentation.selectedDetentIdentifier = .normal
            
            renameBottomSheet.setUsername(presenter.userData?.name ?? "")
            
            present(renameBottomSheet, animated: true)
        }
        
        targetCard.onTargetTapped = {[weak self] buttonType in
            guard let self else { return }
            
            switch buttonType {
            case .memorization:
                let userOptions = UserOptions.dailyVersesTarget
                
                targetBottomSheet.configure(
                    data: userOptions,
                    value: presenter.userData?.dailyVerseTarget ?? 0,
                    title: "Target Harian",
                    subtitle: "Berapa ayat yang ingin kamu hafal setiap hari?",
                    type: .daily
                )
                
                targetBottomSheet.modalPresentationStyle = .overFullScreen
                targetBottomSheet.modalTransitionStyle = .crossDissolve
                
                present(targetBottomSheet, animated: false)
            case .dailyTime:
                let userOptions = UserOptions.dailyTimeTarget
                
                targetBottomSheet.configure(
                    data: userOptions,
                    value: presenter.userData?.dailyStudyTime ?? 0,
                    title: "Waktu Belajar",
                    subtitle: "Berapa waktu yang bisa kamu luangkan setiap hari?",
                    type: .time
                )
                
                targetBottomSheet.modalPresentationStyle = .overFullScreen
                targetBottomSheet.modalTransitionStyle = .crossDissolve
                
                present(targetBottomSheet, animated: false)
            case .target:
                print("Target popup")
                return
            }
        }
        
        reminderCard.onNeedNotificationPermission = {[weak self] in
            guard let self else { return }
            
            ReminderManager.shared.checkPermissionStatus { status in
                switch status {
                case .authorized:
                    self.reminderCard.updateSwitch(isOn: true)
                    // save reminder
                case .denied:
                    self.reminderCard.updateSwitch(isOn: false)
                    self.showNotificationPermissionAlert()
                case .notDetermined:
                    ReminderManager.shared.requestPermission { granted in
                        self.reminderCard.updateSwitch(isOn: granted)
                        
                        if granted {
                            // save reminder
                        }
                    }
                }
            }
        }
        
        renameBottomSheet.onSave = {[weak self] username in
            guard let self else { return }
            
            usernameCard.showAnimatedGradientSkeleton()
            presenter.saveUsername(username)
        }
        
        targetBottomSheet.onSaveTapped = {[weak self] value, type in
            guard let self else { return }
            targetCard.showAnimatedGradientSkeleton()
            
            switch type {
            case .daily:
                presenter.userData?.dailyVerseTarget = value
            case .time:
                presenter.userData?.dailyStudyTime = value
            default:
                break
            }
            
            presenter.saveUserData()
        }
        
    }
    
    private func listener() {
        presenter.onFetchUserData = {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.userData = response
                usernameCard.configuration(nameString: response.name)
                usernameCard.hideSkeleton()
                
                targetCard.configure(subtitle: "\(response.dailyVerseTarget) ayat perhari", type: .memorization)
                targetCard.configure(subtitle: "\(response.dailyStudyTime) menit perhari", type: .dailyTime)
                targetCard.hideSkeleton()
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        presenter.onGetActiveTarget = {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.activeTarget = response
                
                targetCard.configure(subtitle: "\(response?.targetType?.rawValue ?? "") \(response?.targetNumber ?? 0)", type: .target)
                targetCard.hideSkeleton()
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        presenter.onGetReminderData = {[weak self] response in
            guard let self else { return }
            var data: ReminderSetting
            
            if let response {
                data = response
            } else {
                data = ReminderSetting(isEnabled: false, hour: 5, minute: 30, selectedDays: [.sen, .sel, .rab, .kam, .jum, .sab, .min])
            }
            
            reminderCard.configure(data)
            reminderCard.hideSkeleton()
        }
        
        presenter.onGetAllTask = {[weak self] data in
            guard let self else { return }
            statisticCard.configure(data)
            statisticCard.hideSkeleton()
        }
    }
    
    private func initService() {
        mainVStack.showAnimatedGradientSkeleton()
        presenter.initialFetch()
    }
    
    private func showNotificationPermissionAlert() {
        let alert = UIAlertController(
            title: "Izin Notifikasi Diperlukan",
            message: "Aktifkan notifikasi di Pengaturan agar Kuttaib dapat mengirim pengingat hafalan.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Batal",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Buka Pengaturan",
                style: .default
            ) { _ in

                guard let url = URL(
                    string: UIApplication.openSettingsURLString
                ) else { return }

                UIApplication.shared.open(url)
            }
        )

        present(alert, animated: true)
    }
}
