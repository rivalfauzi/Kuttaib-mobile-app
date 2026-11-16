//
//  DetailTargetViewController.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit
import SkeletonView

final class DetailTargetViewController: BaseViewController {
    private let presenter: DetailTargetPresenter
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainVStack = UIStackView()
    
    private let headerView = DetailHeaderCard()
    private let ayahListView = DaftarAyatView()
    private let mainButton = PrimaryButton(title: "")
    private let notesLabel = UILabel()
    private let noteView = UIView()
    private let bottomVStack = UIStackView()
    
    init(presenter: DetailTargetPresenter) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupService()
    }
    
    private func setup() {
        title = "Detail Target"
        
        notesLabel.font = .systemFont(ofSize: 13)
        notesLabel.textColor = .systemGray
        notesLabel.numberOfLines = 0
        notesLabel.textAlignment = .left
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noteView.addSubview(notesLabel)
        noteView.backgroundColor = .backgroundGold
        noteView.layer.cornerRadius = 16
        noteView.isHidden = true
        
        [headerView, noteView, ayahListView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        headerView.isSkeletonable = true
        headerView.skeletonCornerRadius = 24
        
        mainVStack.isSkeletonable = true
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainVStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        [mainButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomVStack.addArrangedSubview($0)
        }
        
        bottomVStack.axis = .vertical
        bottomVStack.alignment = .fill
        bottomVStack.distribution = .fill
        bottomVStack.spacing = 0
        bottomVStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomVStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomVStack.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            bottomVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            notesLabel.topAnchor.constraint(equalTo: noteView.topAnchor, constant: 16),
            notesLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 24),
            notesLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -24),
            notesLabel.bottomAnchor.constraint(equalTo: noteView.bottomAnchor, constant: -16),
        ])
        
        mainButton.addTarget(self, action: #selector(onMainButtonTapped), for: .touchUpInside)
    }
    
    private func setupService() {
        headerView.showAnimatedGradientSkeleton()
        mainButton.showAnimatedGradientSkeleton()
        ayahListView.startLoading()
        presenter.fetchData()
    }
    
    private func setupAction() {
        presenter.onGetData = {[weak self] in
            guard let self, let totalVerseCount = presenter.targetData.totalVerseCount, let completedVerseCount = presenter.targetData.completedVerseCount else { return }
            
            switch presenter.targetData.targetType {
            case .surah:
                guard let surahData = presenter.surahData else { return }
                
                headerView.configure(surahData, target: presenter.targetData, user: presenter.userData)
                
                switch presenter.targetData.status {
                case .active:
                    noteView.isHidden = true
                    mainButton.isHidden = false
                    mainButton.updateTitle("Lanjutkan Tugas Hari Ini")
                case .done:
                    notesLabel.text = "Target ini sudah selesai. Kamu tetap bisa mengulang ayat untuk menjaga hafalan."
                    noteView.isHidden = false
                    mainButton.isHidden = true
                case .inActive:
                    notesLabel.text = "Mengaktifkan target ini akan menonaktifkan target yang sedang aktif tanpa menghapus progres yang telah dicapai."
                    noteView.isHidden = false
                    mainButton.isHidden = false
                    mainButton.updateTitle("Aktifkan Target")
                default:
                    break
                }
                
                if presenter.targetData.completedVerseCount ?? 0 >= presenter.targetData.totalVerseCount ?? 0 {
                    mainButton.isEnabled = false
                }
                
                headerView.hideSkeleton()
                mainButton.hideSkeleton()
            default:
                break
            }
            
            let dataItems = presenter.generateSections(totalVerseCount: totalVerseCount, completedVerseCount: completedVerseCount, tasks: presenter.targetData.tasks ?? [])
            ayahListView.configure(dataItems)
            ayahListView.hideSkeleton()
        }
        
        ayahListView.onContinue = {[weak self] item in
            switch item.status {
            case .completed:
                self?.presenter.navigateTo(.murojaahTask(item))
            case .current:
                self?.onMainButtonTapped()
            default:
                break
            }
        }
    }
    
    @objc private func onMainButtonTapped() {
        switch presenter.targetData.status {
        case .active:
            presenter.navigateTo(.ziyadahTask)
        case .inActive:
            print("Aktifkan target")
        default:
            break
        }
    }
}
