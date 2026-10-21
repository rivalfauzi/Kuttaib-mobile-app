//
//  TargetPickerBottomSheet.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import UIKit

final class TargetPickerBottomSheet: UIViewController {
    var didSelect: ((Int, TargetType, String) -> Void)?

    private var selectedTab: TargetType = .juz
    private let juzButton = UIButton(type: .system)
    private let surahButton = UIButton(type: .system)
    private let tableView = UITableView()

    private let juzItems = Array(1...30)

    var surahItems: [Quran.Surah.Response] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    private func setup() {
        let titleLabel = UILabel()
        titleLabel.text = "Pilih Target Hafalan"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        let tabStack = UIStackView(
            arrangedSubviews: [
                juzButton,
                surahButton
            ]
        )

        tabStack.axis = .horizontal
        tabStack.spacing = 8
        tabStack.distribution = .fillEqually

        juzButton.setTitle("Juz", for: .normal)
        surahButton.setTitle("Surah", for: .normal)

        juzButton.addTarget(self, action: #selector(juzTapped), for: .touchUpInside)
        surahButton.addTarget(self, action: #selector(surahTapped), for: .touchUpInside)

        updateTabState()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        [titleLabel, tabStack, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tabStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tabStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tabStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tabStack.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: tabStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateTabState() {
        let selectedColor = UIColor.primaryGreen
        let unselectedColor = UIColor.systemGray6
        
        juzButton.layer.cornerRadius = 12
        surahButton.layer.cornerRadius = 12
        
        switch selectedTab {
        case .juz:
            juzButton.backgroundColor = selectedColor
            surahButton.backgroundColor = unselectedColor
            juzButton.setTitleColor(.white, for: .normal)
            surahButton.setTitleColor(.black, for: .normal)
        case .surah:
            juzButton.backgroundColor = unselectedColor
            surahButton.backgroundColor = selectedColor
            juzButton.setTitleColor(.black, for: .normal)
            surahButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func juzTapped() {
        selectedTab = .juz
        updateTabState()
        tableView.reloadData()
    }

    @objc private func surahTapped() {
        selectedTab = .surah
        updateTabState()
        tableView.reloadData()
    }
}

extension TargetPickerBottomSheet: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .juz:
            return juzItems.count
        case .surah:
            return surahItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch selectedTab {
        case .juz:
            cell.textLabel?.text = "Juz \(juzItems[indexPath.row])"
        case .surah:
            cell.textLabel?.text = "\(indexPath.row + 1). \(surahItems[indexPath.row].englishName)"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < surahItems.count else { return }
        let name = selectedTab == .surah ? surahItems[indexPath.row].englishName : ""
        didSelect?((indexPath.row + 1), selectedTab, name)

        dismiss(animated: true)
    }
}
