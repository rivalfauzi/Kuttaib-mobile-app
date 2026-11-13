//
//  DaftarAyatView.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit
import SkeletonView

final class DaftarAyatView: UIView {

    private let titleLabel = UILabel()
    private let cardView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private var tableHeightConstraint: NSLayoutConstraint!

    private var sections: [AyatSection] = []
    private var flattenedItems: [AyatListItem] = []
    
    var onContinue: ((AyatItem) -> Void)?
    
    private var isLoading = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard window != nil else { return }
        updateTableHeight()
    }

    private func setupView() {
        titleLabel.text = "Daftar Ayat"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        cardView.isSkeletonable = true
        cardView.skeletonCornerRadius = 24

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.register(AyatHeaderCell.self, forCellReuseIdentifier: AyatHeaderCell.reuseIdentifier)
        tableView.register(DetailAyahCell.self, forCellReuseIdentifier: DetailAyahCell.reuseIdentifier)

        [titleLabel, cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(tableView)

        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            tableView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            tableHeightConstraint
        ])
    }

    // MARK: Public
    func configure(_ sections: [AyatSection]) {
        isLoading = false
        self.sections = sections
        rebuildItems()
        tableView.hideSkeleton()
        tableView.reloadData()
        
        guard window != nil else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self, self.window != nil else { return }
            updateTableHeight()
        }
    }
    
    func startLoading() {
        isLoading = true
        tableHeightConstraint.constant = 300
        layoutIfNeeded()
        cardView.showAnimatedGradientSkeleton()
    }

    private func rebuildItems() {
        flattenedItems.removeAll()
        for section in sections {
            flattenedItems.append(.header(section))

            if section.isExpanded {
                section.items.forEach {
                    flattenedItems.append(.ayat($0))
                }
            }
        }
    }

    private func updateTableHeight() {
        guard !isLoading, window != nil, tableView.window != nil else { return }
        
        tableView.layoutIfNeeded()
        let newHeight = tableView.contentSize.height
        
        if tableHeightConstraint.constant != newHeight {
            tableHeightConstraint.constant = newHeight
        }
    }
    
    private func handleTap(_ item: AyatItem) {
        onContinue?(item)
    }
}

// MARK: - UITableViewDataSource
extension DaftarAyatView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flattenedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = flattenedItems[indexPath.row]
        
        switch item {
        case .header(let section):
            let cell = tableView.dequeueReusableCell(withIdentifier: AyatHeaderCell.reuseIdentifier, for: indexPath) as! AyatHeaderCell

            cell.configure(
                title: section.title,
                subtitle: section.subtitle,
                expanded: section.isExpanded
            )

            cell.tapAction = { [weak self] in
                guard let self, let index = self.sections.firstIndex(where: {
                    $0.id == section.id
                }) else { return }

                self.sections[index].isExpanded.toggle()
                self.rebuildItems()
                self.tableView.reloadData()

                DispatchQueue.main.async {
                    self.updateTableHeight()
                }
            }

            return cell

        case .ayat(let ayat):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailAyahCell.reuseIdentifier, for: indexPath) as! DetailAyahCell
            
            cell.configure(ayat)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .ayat(ayat) = flattenedItems[indexPath.row], ayat.status != .upcoming, let cell = tableView.cellForRow(at: indexPath) else { return }

        UIView.animate(
            withDuration: 0.1,
            animations: {
                cell.transform = CGAffineTransform(
                    scaleX: 0.97,
                    y: 0.97
                )
            },
            completion: {[weak self] _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
                
                self?.handleTap(ayat)
            }
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < flattenedItems.count else {
            return 70
        }
        
        let item = flattenedItems[indexPath.row]

        switch item {
        case .header:
            return 72
        case .ayat:
            return 70
        }
    }
}

// MARK: - Header Cell

final class AyatHeaderCell: UITableViewCell {
    static let reuseIdentifier = "AyatHeaderCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()

    var tapAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2

        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = .systemGray2

        let leftStack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                subtitleLabel
            ]
        )

        leftStack.axis = .vertical
        leftStack.spacing = 4

        let spacer = UIView()

        let stack = UIStackView(
            arrangedSubviews: [
                leftStack,
                spacer,
                chevronImageView
            ]
        )

        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
    }

    func configure(title: String, subtitle: String, expanded: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle

        chevronImageView.transform = expanded ? CGAffineTransform(rotationAngle: .pi) : .identity
    }

    @objc private func didTap() {
        tapAction?()
    }
}

final class DetailAyahCell: UITableViewCell {
    
    static let reuseIdentifier = "AyatCell"
    
    private let badgeContainer = UIView()
    private let badgeLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let centerVStack = UIStackView()
    private let rightIcon = UIIconView()
    private let mainHStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        badgeLabel.text = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        
        resetUI()
    }
    
    private func setupView() {
        selectionStyle = .none
        
        badgeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.textColor = .primaryGreen
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        badgeContainer.backgroundColor = .backgroundGreen
        badgeContainer.layer.cornerRadius = 12
        badgeContainer.addSubview(badgeLabel)
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2
        
        [titleLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 4
        centerVStack.alignment = .fill
        centerVStack.distribution = .fill
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        [badgeContainer, centerVStack, spacer, rightIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 16
        mainHStack.alignment = .center
        mainHStack.distribution = .fill
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor),
            
            badgeContainer.heightAnchor.constraint(equalToConstant: 44),
            badgeContainer.widthAnchor.constraint(equalToConstant: 44),
            
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            rightIcon.heightAnchor.constraint(equalToConstant: 40),
            rightIcon.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configure(_ item: AyatItem) {
        
        resetUI()
        
        badgeLabel.text = "\(item.number)"
        
        switch item.status {
            
        case .completed:
            rightIcon.configure(iconImage: UIImage(systemName: "arrow.clockwise"), iconTintColor: .primaryGreen, background: .backgroundGreen, ratio: 0.5, cornerRadius: 20)
            titleLabel.text = "Dihafal"
            
            if let repetition = item.repetition, repetition != 0 {
                subtitleLabel.text = "Diulang \(repetition)x"
            } else {
                subtitleLabel.text = "Belum diulang"
            }
            
        case .current:
            rightIcon.configure(iconImage: UIImage(systemName: "play.fill"), iconTintColor: .white, background: .primaryGreen, ratio: 0.5, cornerRadius: 20)
            
            contentView.backgroundColor = .backgroundGreen.withAlphaComponent(0.3)
            badgeContainer.backgroundColor = .primaryGreen
            badgeLabel.textColor = .white
            titleLabel.text = "Lanjutkan"
            var subtitleString = ""
            
            if let isToday = item.isToday, isToday {
                subtitleString = "Hari ini • "
            }
            
            subtitleString += "Hafalan selanjutnya"
            
            subtitleLabel.text = subtitleString
        case .upcoming:
            rightIcon.configure(iconImage: UIImage(systemName: "clock.badge.checkmark"), iconTintColor: .systemGray, background: .systemGray5)
            
            badgeLabel.textColor = .systemGray
            badgeContainer.backgroundColor = .systemGray5
            contentView.alpha = 0.5
            titleLabel.text = "Belum dihafal"
            
            if let isToday = item.isToday, isToday {
                subtitleLabel.text = "Hari ini"
            }
            
        }
    }
    
    private func resetUI() {
        contentView.backgroundColor = .clear
        contentView.alpha = 1

        badgeContainer.backgroundColor = .backgroundGreen

        badgeLabel.textColor = .primaryGreen

        rightIcon.configure(
            iconImage: nil,
            iconTintColor: .clear,
            background: .clear
        )
    }
}
