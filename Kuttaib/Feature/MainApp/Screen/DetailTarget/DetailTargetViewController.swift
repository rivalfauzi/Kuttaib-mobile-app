//
//  DetailTargetViewController.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit

final class DetailTargetViewController: BaseViewController {
    private let presenter: DetailTargetPresenter
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainVStack = UIStackView()
    
    private let headerView = DetailHeaderCard()
    private let ayahListView = DaftarAyatView()
    private let mainButton = PrimaryButton(title: "Lanjutkan Tugas Hari Ini")
    
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
        setupService()
    }
    
    private func setup() {
        title = "Detail Target"
        
        [headerView, ayahListView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainVStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mainButton.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        ayahListView.configure([
            AyatSection(
                title: "Ayat 1 - 10",
                subtitle: "10/10 dihafal",
                isExpanded: false,
                items: []
            ),

            AyatSection(
                title: "Ayat 11 - 20",
                subtitle: "10/10 dihafal",
                isExpanded: false,
                items: []
            ),

            AyatSection(
                title: "Ayat 21 - 30",
                subtitle: "6/10 dihafal · 4 dalam tugas hari ini",
                isExpanded: true,
                items: [

                    AyatItem(
                        number: 21,
                        title: "Dihafal",
                        subtitle: "Diulang 1x",
                        status: .completed
                    ),

                    AyatItem(
                        number: 22,
                        title: "Dihafal",
                        subtitle: "Hari ini · Belum diulang",
                        status: .completed
                    ),

                    AyatItem(
                        number: 23,
                        title: "Dihafal",
                        subtitle: "Hari ini · Belum diulang",
                        status: .completed
                    ),

                    AyatItem(
                        number: 27,
                        title: "Belum dihafal",
                        subtitle: "Tugas hari ini",
                        status: .today
                    ),

                    AyatItem(
                        number: 28,
                        title: "Belum dihafal",
                        subtitle: "Tugas hari ini",
                        status: .upcoming
                    )
                ]
            ),

            AyatSection(
                title: "Ayat 31 - 40",
                subtitle: "0/10 dihafal · 1 dalam tugas hari ini",
                isExpanded: false,
                items: []
            )
        ])
    }
    
    private func setupService() {
        switch presenter.targetData.targetType {
        case .surah:
            presenter.fetchSurahData {[weak self] result in
                guard let self else { return }
                
                let targetNumber = presenter.targetData.targetNumber
                
                switch result {
                case .success(let response):
                    let targetSurahData = response.first {
                        $0.number == targetNumber
                    }
                    
                    guard let targetSurahData else { return }
                    
                    presenter.surahData = targetSurahData
                    headerView.configure(targetSurahData, target: presenter.targetData, user: presenter.userData)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        default:
            break
        }
    }
}
