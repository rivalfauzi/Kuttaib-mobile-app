//
//  DaftarAyatView.swift
//  Kuttaib
//
//  Created by mco on 06/11/26.
//

import UIKit

final class DaftarAyatView: UIView {

    let titleLabel = UILabel()
    let contentView = UIView()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var tableHeightConstraint: NSLayoutConstraint!
    
    private var sections: [AyatSection] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableHeight()
    }

    private func setupView() {
        titleLabel.text = "Daftar Ayat"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        
        contentView.addSubview(tableView)
        contentView.layer.cornerRadius = 24
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white
        
        tableView.register(DetailAyahCell.self, forCellReuseIdentifier: DetailAyahCell.reuseIdentifier)
        tableView.register(AyatSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AyatSectionHeaderView.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 24
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            tableHeightConstraint
        ])
    }
    
    private func updateTableHeight() {
        tableView.layoutIfNeeded()
        tableHeightConstraint.constant = tableView.contentSize.height
    }
    
    func configure(_ data: [AyatSection]) {
        sections = data
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.updateTableHeight()
        }
    }
}

extension DaftarAyatView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections[section].isExpanded else { return 0 }
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailAyahCell.reuseIdentifier, for: indexPath) as! DetailAyahCell

        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(item)
        return cell
    }
}

extension DaftarAyatView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AyatSectionHeaderView.reuseIdentifier) as! AyatSectionHeaderView

        let sectionData = sections[section]

        header.configure(
            title: sectionData.title,
            subtitle: sectionData.subtitle,
            expanded: sectionData.isExpanded
        )

        header.tapAction = { [weak self] in
            guard let self else { return }

            self.sections[section].isExpanded.toggle()
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)

            DispatchQueue.main.async {
                self.updateTableHeight()
            }
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

final class AyatSectionHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "AyatSectionHeaderView"
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let chevronImageView = UIImageView()
    
    var tapAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.backgroundColor = .white

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        
        chevronImageView.image = UIImage(systemName: "chevron.down")
        
        [titleLabel, subtitleLabel, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(title: String, subtitle: String, expanded: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = expanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    @objc private func didTap() {
        tapAction?()
    }
}

final class DetailAyahCell: UITableViewCell {
    
    static let reuseIdentifier = "AyatCell"
    
    private let badgeLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let playButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        let badgeContainer = UIView()
        badgeContainer.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        badgeContainer.layer.cornerRadius = 14
        
        badgeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        badgeLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        nextButton.setTitle("Berikutnya", for: .normal)
        nextButton.backgroundColor = .systemGreen
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 14
        
        let textStack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                subtitleLabel
            ]
        )
        
        textStack.axis = .vertical
        
        [badgeContainer, textStack, playButton, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        badgeContainer.addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            badgeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            badgeContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeContainer.widthAnchor.constraint(equalToConstant: 40),
            badgeContainer.heightAnchor.constraint(equalToConstant: 40),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor),
            
            textStack.leadingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nextButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 90),
            nextButton.heightAnchor.constraint(equalToConstant: 28),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 62)
        ])
    }
    
    func configure(_ item: AyatItem) {
        
        badgeLabel.text = "\(item.number)"
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        playButton.isHidden = true
        nextButton.isHidden = true
        
        switch item.status {
            
        case .completed:
            playButton.isHidden = false
            
        case .today:
            nextButton.isHidden = false
            
        case .upcoming:
            break
        }
    }
}
