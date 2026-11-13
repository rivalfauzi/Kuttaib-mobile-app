//
//  HomeViewController.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import UIKit
import SkeletonView

final class HomeViewController: BaseViewController {
    let presenter: HomePresenter
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let targetCard = HomeHeroCard()
    private let taskSection = TaskSection()
    private let statisticSection = HomeStatisticsView()
    private let recomenSection = HomeRecomendationView()
    
    private let mainVStack = UIStackView()
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    
    private var recomendationData: [HomeRecomendationEntity] = []
    
    init(presenter: HomePresenter) {
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
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        recomendationData = []
        targetCard.showAnimatedGradientSkeleton()
        taskSection.startLoading()
        statisticSection.startLoading()
        recomenSection.showAnimatedGradientSkeleton()
        presenter.initialService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainVStack)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.text = "Assalamu'alaikum"
        
        descLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.text = "Semoga hari ini lebih dekat dengan Al-Qur'an"
        
        [titleLabel, descLabel, targetCard, taskSection, statisticSection, recomenSection].forEach {
            $0.isSkeletonable = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        targetCard.skeletonCornerRadius = 24
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.distribution = .fill
        mainVStack.alignment = .fill
        
        mainVStack.setCustomSpacing(4, after: titleLabel)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // Penting agar lebar content mengikuti screen
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // StackView
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupListener() {
        presenter.onFetchUserData = {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                presenter.userData = response
                
                if !response.reminderEnabled {
                    recomendationData.append(
                        HomeRecomendationEntity(
                            icon: "book.fill",
                            iconTintColor: .primaryBlue,
                            backgroundIcon: .backgroundBlue,
                            title: "Atur Pengingat Hafalan",
                            description: "Pilih jam favoritmu supaya fokus hafalan tidak terlewat. Bisa diatur kapan saja di Profil.",
                            buttonTitle: "Atur di Profil",
                            buttonKey: .reminder
                        )
                    )
                }
                
                titleLabel.text = "Assalamu'alaikum \(response.name)"
                titleLabel.hideSkeleton()
                descLabel.hideSkeleton()
            case .failure(let error):
                print(error)
            }
        }
        
        presenter.onFetchTargetData = {[weak self] data in
            guard let self, let surahsData = presenter.surahData else { return }
            
            if let data, let surah = surahsData.first(where: {
                $0.number == data.targetNumber
            }) {
                targetCard.setConfig(data, surah: surah)
            } else {
                targetCard.setEmptyState()
            }
            
            targetCard.hideSkeleton()
        }
        
        presenter.onFetchTaskData = {[weak self] data in
            guard let self else { return }
            
            if data.isEmpty {
                taskSection.isHidden = true
            } else {
                taskSection.isHidden = false
                taskSection.setDataTask(data, surahData: presenter.surahData)
            }
            
            recomenSection.setData(recomendationData)
        }
        
        presenter.onFetchAllTaskData = {[weak self] data in
            guard let self, let target = presenter.userData?.dailyVerseTarget else { return }
            
            statisticSection.setConfiguration(data, dailyTarget: target)
        }
    }
    
    private func setupAction() {
        taskSection.onTappedButton = {[weak self] task, surah in
            guard let self, let user = presenter.userData else { return }
            
            switch task.type {
            case .ziyadah:
                presenter.navigateTo(.memorizationSession(task: task, user: user, surah: surah))
            case .murojaah:
                presenter.navigateTo(.murojaahSession(task: task, surah: surah))
            default:
                break
            }
        }
        
        recomenSection.onCellButtonTapped = {[weak self] key in
            guard let self else { return }
            
            switch key {
            case .reminder:
                self.presenter.switchTabBar(.profile)
            }
        }
        
        targetCard.onDetailTapped = {[weak self] in
            guard let self, let user = presenter.userData else { return }
            
            presenter.navigateTo(.targetDetail(user: user))
        }
        
        targetCard.onNewTarget = {[weak self] in
            guard let self, let surahData = presenter.surahData else { return }
            
            let switchTargetBottomSheet = TargetPickerBottomSheet()
            
            switchTargetBottomSheet.setData(surahData)
            switchTargetBottomSheet.userDailyTarget = self.presenter.userData?.dailyVerseTarget
            
            switchTargetBottomSheet.didSelect = { item in
                self.targetChange(item)
            }
            
            if let presentation = switchTargetBottomSheet.sheetPresentationController {
                presentation.detents = [.large()]
                presentation.prefersGrabberVisible = false
                
                switchTargetBottomSheet.isModalInPresentation = true
                self.present(switchTargetBottomSheet, animated: true)
            }
        }
    }
    
    private func targetChange(_ item: Quran.Surah.Response) {
        recomendationData = []
        targetCard.showAnimatedGradientSkeleton()
        taskSection.startLoading()
        statisticSection.startLoading()
        recomenSection.showAnimatedGradientSkeleton()
        
        presenter.createNewTarget(surahData: item) {[weak self] in
            self?.presenter.initialService()
        }
    }
}

final class HomeHeroCard: UIView {
    let titleCard = UILabel()
    let targetLabel = UILabel()
    let descLabel = UILabel()
    let detailButton = PrimaryButton(title: "Lihat Detail")
    let leftVStack = UIStackView()
    
    let progressView = CircularProgressView()
    let progressLabel = UILabel()
    let rightView = UIView()
    let mainHStack = UIStackView()
    
    var onDetailTapped:(() -> Void)?
    var onNewTarget: (() -> Void)?
    
    var isEmpty = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .white
        
        titleCard.text = "Target Hafalan"
        titleCard.font = .systemFont(ofSize: 14, weight: .regular)
        titleCard.textColor = .systemGray2
        titleCard.numberOfLines = 0
        
        targetLabel.font = .systemFont(ofSize: 18, weight: .bold)
        targetLabel.textColor = .black
        targetLabel.numberOfLines = 0
        
        descLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        
        detailButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        detailButton.layer.cornerRadius = 22
        detailButton.setHeight(44)
        
        [titleCard, targetLabel, descLabel, detailButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            leftVStack.addArrangedSubview($0)
        }
        
        leftVStack.axis = .vertical
        leftVStack.spacing = 8
        leftVStack.alignment = .fill
        leftVStack.distribution = .fill
        leftVStack.setCustomSpacing(16, after: descLabel)
        
        progressLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        [progressView, progressLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            rightView.addSubview($0)
        }
        
        [leftVStack, rightView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 16
        mainHStack.alignment = .fill
        mainHStack.distribution = .fillEqually
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            progressView.widthAnchor.constraint(equalTo: rightView.heightAnchor),
            progressView.heightAnchor.constraint(equalTo: rightView.heightAnchor),
            progressView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
            
            progressLabel.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
        ])
        
        detailButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    func setConfig(_ data: TargetModel, surah: Quran.Surah.Response) {
        guard let completedVerseCount = data.completedVerseCount, let totalVerseCount = data.totalVerseCount else { return }
        
        targetLabel.text = "Surah \(surah.englishName)"
        descLabel.text = "\(completedVerseCount)/\(totalVerseCount) ayat"
        
        let percentage = CGFloat(completedVerseCount) / CGFloat(totalVerseCount)
        let percentageText = String(format: "%.1f%%", percentage * 100)
        
        progressView.progress = percentage
        progressLabel.text = percentageText
        detailButton.updateTitle("Lihat Detail")
        
        rightView.isHidden = false
        isEmpty = false
    }
    
    func setEmptyState() {
        targetLabel.text = "Tidak Ada Target Aktif"
        descLabel.text = "Pilih surah yang ingin kamu hafal untuk mulai mendapat tugas harian."
        detailButton.updateTitle("Pilih Target")
        
        rightView.isHidden = true
        isEmpty = true
    }
    
    @objc private func onButtonTapped() {
        if isEmpty {
            onNewTarget?()
        } else {
            onDetailTapped?()
        }
    }
}

final class TaskSection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    let title = UILabel()
    let taskCollection: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    private var collectionHeightConstraint: NSLayoutConstraint!
    
    var dataTask: [TaskModel] = []
    var surahData: [Quran.Surah.Response]?
    
    var onTappedButton: ((TaskModel, Quran.Surah.Response?)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.text = "Tugas Hari Ini"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        
        taskCollection.delegate = self
        taskCollection.dataSource = self
        taskCollection.register(HomeTaskCollectionViewCell.self, forCellWithReuseIdentifier: HomeTaskCollectionViewCell.identifier)
        taskCollection.backgroundColor = .clear
        taskCollection.isScrollEnabled = false
        taskCollection.isSkeletonable = true
        
        collectionHeightConstraint = taskCollection.heightAnchor.constraint(equalToConstant: 0)
        
        [title, taskCollection].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            taskCollection.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            taskCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
            taskCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            taskCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionHeightConstraint
        ])
    }
    
    func startLoading() {
        collectionHeightConstraint.constant = 90
        layoutIfNeeded()
        taskCollection.showAnimatedGradientSkeleton()
    }
    
    func setDataTask(_ items: [TaskModel], surahData: [Quran.Surah.Response]?) {
        dataTask = items
        self.surahData = surahData
        taskCollection.hideSkeleton(reloadDataAfter: true)
        taskCollection.layoutIfNeeded()

        collectionHeightConstraint.constant = taskCollection
            .collectionViewLayout.collectionViewContentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataTask.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTaskCollectionViewCell.identifier, for: indexPath) as! HomeTaskCollectionViewCell
        
        let taskData = dataTask[indexPath.item]
        
        let surah = surahData?.first {
            $0.number == taskData.surahNumber
        }
        
        cell.onTappedRightButton = { [weak self] in
            self?.onTappedButton?(taskData, surah)
        }
        
        cell.setCofigure(taskData, surahName: surah?.englishName ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 90)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        HomeTaskCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
}

