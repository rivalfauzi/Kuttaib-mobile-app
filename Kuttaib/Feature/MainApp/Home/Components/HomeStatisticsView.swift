//
//  HomeStatisticsView.swift
//  Kuttaib
//
//  Created by mco on 30/10/26.
//

import UIKit
import SkeletonView

final class HomeStatisticsView: UIView {
    private let title = UILabel()
    private let dateLabel = UILabel()
    private let titleHStack = UIStackView()
    private let totalAyahComponent = StatisticComponents()
    private let strikeComponent = StatisticComponents()
    private let averageComponent = StatisticComponents()
    private let topHStack = UIStackView()
    private let separator = UIView()
    private let progressCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let contentView = UIView()
    
    private var startDate: Date = Date()
    private var endDate: Date = Date()
    private var dateText: String = ""
    private var weeklyProgress: [WeeklyProgress] = []
    private var dailyTarget: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isSkeletonable = true
        
        title.text = "Statistik Minggu Ini"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textAlignment = .left
        
        currentWeekRangeText()
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .systemGray2
        dateLabel.text = dateText
        dateLabel.textAlignment = .right
        
        [title, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleHStack.addArrangedSubview($0)
        }
        
        titleHStack.axis = .horizontal
        titleHStack.spacing = 0
        titleHStack.alignment = .fill
        titleHStack.distribution = .fillEqually
        
        [totalAyahComponent, strikeComponent, averageComponent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 4
        topHStack.alignment = .fill
        topHStack.distribution = .fillEqually
        
        separator.backgroundColor = .systemGray4
        
        progressCollection.delegate = self
        progressCollection.dataSource = self
        progressCollection.register(WeeklyBarCell.self, forCellWithReuseIdentifier: WeeklyBarCell.identifier)
        
        [topHStack, separator, progressCollection].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        contentView.isSkeletonable = true
        contentView.skeletonCornerRadius = 24
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        
        [titleHStack, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleHStack.topAnchor.constraint(equalTo: topAnchor),
            titleHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: titleHStack.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            topHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            topHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: topHStack.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            progressCollection.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            progressCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            progressCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            progressCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            progressCollection.heightAnchor.constraint(equalToConstant: 140)
            
        ])
    }
    
    private func currentWeekRangeText() {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return
        }

        let startDate = weekInterval.start
        let endDate = calendar.date(
            byAdding: .day,
            value: 6,
            to: startDate
        )!
        
        self.startDate = startDate
        self.endDate = endDate

        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "id_ID")
        dayFormatter.dateFormat = "d"

        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "id_ID")
        monthFormatter.dateFormat = "MMM"

        let startDay = dayFormatter.string(from: startDate)
        let startMonth = monthFormatter.string(from: startDate)

        let endDay = dayFormatter.string(from: endDate)
        let endMonth = monthFormatter.string(from: endDate)

        self.dateText = "\(startDay) \(startMonth) - \(endDay) \(endMonth)"
    }
    
    private func calculateCurrentStreak(_ tasks: [TaskModel]) -> Int {
        let calendar = Calendar.current
        let uniqueDays = Set(
            tasks.compactMap {
                $0.taskDate.map {
                    calendar.startOfDay(for: $0)
                }
            }
        )

        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        if !uniqueDays.contains(today),
           let yesterday = calendar.date(
               byAdding: .day,
               value: -1,
               to: today
           ),
           uniqueDays.contains(yesterday) {
            currentDate = yesterday
        }

        var streak = 0

        while uniqueDays.contains(currentDate) {

            streak += 1

            guard let previousDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDate
            ) else {
                break
            }

            currentDate = previousDay
        }

        return streak
    }
    
    func startLoading() {
        contentView.showAnimatedGradientSkeleton()
    }
    
    func setConfiguration(_ tasks: [TaskModel], dailyTarget: Int) {
        let weeklyTasks = tasks.filter {
            guard let taskDate = $0.taskDate else { return false }
            return taskDate >= startDate && taskDate <= endDate
        }
        let strike = calculateCurrentStreak(tasks)
        self.dailyTarget = dailyTarget
        
        setWeeklyAyat(weeklyTasks)
        setDefaultData(weeklyTasks)
        
        strikeComponent.setConfig(HomeStatisticsEntity(title: "\(strike)", description: "Hari strike", icon: "flame.fill", iconTintColor: .primaryRed, backgroundIcon: .backgroundRed))
        
        contentView.hideSkeleton()
    }
    
    private func setWeeklyAyat(_ tasks: [TaskModel]) {
        let ziyadahTasks = tasks.filter {
            $0.type == .ziyadah
        }
        
        var totalAyah: Int = 0
        var median = "0.0"
        
        if !ziyadahTasks.isEmpty {
            totalAyah = ziyadahTasks.reduce(0) { result, task in
                return result + (task.completedEndAyah ?? 0)
            }
            
            let doubleMedian = Double(totalAyah) / Double(ziyadahTasks.count)
            median = String(format: "%.1f", doubleMedian)
        }

        totalAyahComponent.setConfig(HomeStatisticsEntity(title: "\(totalAyah)", description: "Ayat dihafal", icon: "book.fill", iconTintColor: .primaryBlue, backgroundIcon: .backgroundBlue))
        
        averageComponent.setConfig(HomeStatisticsEntity(title: median, description: "Ayat per hari", icon: "chart.line.uptrend.xyaxis", iconTintColor: .primaryGreen, backgroundIcon: .backgroundGreen))
    }
    
    private func setDefaultData(_ tasks: [TaskModel]) {
        let calendar = Calendar(identifier: .gregorian)
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "id_ID")
        dayFormatter.dateFormat = "E"
        
        var weeklyProgress: [WeeklyProgress] = []

        for offset in 0...6 {
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else { continue }
            
            let tasksInDay = tasks.filter { task in
                guard let taskDate = task.taskDate else { return false }
                return calendar.isDate(taskDate, inSameDayAs: date)
            }.first

            let dayName = dayFormatter.string(from: date)
            weeklyProgress.append(WeeklyProgress(day: dayName, count: tasksInDay?.completedEndAyah ?? 0, maxCount: dailyTarget))
        }

        self.weeklyProgress = weeklyProgress
        progressCollection.reloadData()
    }
}

extension HomeStatisticsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weeklyProgress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyBarCell.identifier, for: indexPath) as! WeeklyBarCell
        
        let item = weeklyProgress[indexPath.item]
        cell.configure(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 7
        return CGSize(width: width, height: 140)
    }
}

final class StatisticComponents: UIView {
    private let icon = UIIconView()
    
    private let value = UILabel()
    
    private let topHStack = UIStackView()
    private let descComponent = UILabel()
    private let mainVStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        
        value.font = .systemFont(ofSize: 18, weight: .bold)
        value.textColor = .black
        value.textAlignment = .left
        
        [icon, value].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 8
        topHStack.alignment = .fill
        topHStack.distribution = .fill
        
        descComponent.font = .systemFont(ofSize: 14)
        descComponent.textColor = .systemGray2
        descComponent.textAlignment = .left
        descComponent.numberOfLines = 0
        
        [topHStack, descComponent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 8
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.heightAnchor.constraint(equalToConstant: 32),
            icon.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setConfig(_ item: HomeStatisticsEntity) {
        value.text = item.title
        descComponent.text = item.description
        
        icon.configure(iconImage: UIImage(systemName: item.icon), iconTintColor: item.iconTintColor, background: item.backgroundIcon, cornerRadius: 8)
    }
}

final class WeeklyBarCell: UICollectionViewCell {
    static let identifier = "WeeklyBarCell"
    
    private let progressLabel = UILabel()
    private let barView = UIView()
    private let targetBar = UIView()
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    private let mainVStack = UIStackView()

    private var barHeightConstraint: NSLayoutConstraint!
    private var currentRatio: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maxHeight = targetBar.bounds.height
        
        if currentRatio == 0 {
            barHeightConstraint.constant = 0
        } else {
            barHeightConstraint.constant = max(4, currentRatio * maxHeight)
        }
    }
    
    private func setup() {
        progressLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        progressLabel.textAlignment = .center
        progressLabel.textColor = .black
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        targetBar.addSubview(barView)
        
        targetBar.backgroundColor = .systemGray5
        targetBar.layer.cornerRadius = 8

        barView.backgroundColor = .primaryGreen
        barView.layer.cornerRadius = 8
        
        [progressLabel, targetBar, dayLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 8
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        progressLabel.setContentHuggingPriority(.required, for: .vertical)
        dayLabel.setContentHuggingPriority(.required, for: .vertical)
        
        contentView.addSubview(mainVStack)
        
        barHeightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            targetBar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65),
            
            barView.leadingAnchor.constraint(equalTo: targetBar.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: targetBar.trailingAnchor),
            barView.bottomAnchor.constraint(equalTo: targetBar.bottomAnchor),
            
            barHeightConstraint
        ])
    }

    func configure(_ item: WeeklyProgress) {
        dayLabel.text = item.day
        progressLabel.text = "\(item.count)"
        
        if item.count > item.maxCount {
            barView.backgroundColor = .primaryGold
            currentRatio = 1
        } else {
            barView.backgroundColor = .primaryGreen
            currentRatio = item.maxCount > 0 ? CGFloat(item.count) / CGFloat(item.maxCount) : 0
        }
        
        setNeedsLayout()
    }
}
