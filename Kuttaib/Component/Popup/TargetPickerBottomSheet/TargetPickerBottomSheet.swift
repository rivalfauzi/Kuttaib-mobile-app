//
//  TargetPickerBottomSheet.swift
//  Kuttaib
//
//  Created by mco on 15/10/26.
//

import UIKit

final class TargetPickerBottomSheet: UIViewController {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let titleVStack = UIStackView()
    
    private let closeButton = UIButton()
    private let topHStack = UIStackView()
    
    private let juzButton = UIButton(type: .system)
    private let surahButton = UIButton(type: .system)
    private let tabStack = UIStackView()
    
    private let textfieldIcon = UIImageView()
    private let searchTextField = UITextField()
    private let textfieldLeftContainer = UIView()
    
    private let infoIcon = UIImageView()
    private let infoLabel = UILabel()
    private let infoHStack = UIStackView()
    
    private let headerVStack = UIStackView()
    
    private let tableView = UITableView()
    
    private let footerView = UIView()
    private let footerLine = UIView()
    private let footerTitle = UILabel()
    private let footerDesc = UILabel()
    private let footerButton = PrimaryButton(title: "Pilih")
    private let footerVStack = UIStackView()
    
    var didSelect: ((TargetPickerCellEntity) -> Void)?
    var onClose: (() -> Void)?
    
    struct SurahListResponse: Decodable {
        let id: String
        let latinName: String
        let number: Int
        let verseCount: Int
    }
    
    struct JuzListResponse: Decodable {
        let id: String
        let totalPage: Int
        let number: Int
        let totalVerseCount: Int
    }
    
    var userDailyTarget: Int?
    private var originalSurahsData: [SurahListResponse] = []
    private var originalJuzsData: [JuzListResponse] = []
    
    private var filteredData: [TargetPickerCellEntity] = []
    private var selectedData: TargetPickerCellEntity?
    private var previousData: TargetPickerCellEntity?
    
    private var selectedTab: TargetType = .surah

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    private func setup() {
        titleLabel.text = "Pilih Target Hafalan"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        subtitleLabel.text = "Pilih surah yang ingin kamu hafal."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.textAlignment = .left
        
        [titleLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleVStack.addArrangedSubview($0)
        }
        
        titleVStack.axis = .vertical
        titleVStack.spacing = 8
        titleVStack.alignment = .leading
        titleVStack.distribution = .fill
        
        closeButton.setImage( UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.backgroundColor = .systemGray5
        closeButton.layer.cornerRadius = 22
        
        [titleVStack, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 8
        topHStack.alignment = .center
        topHStack.distribution = .fill
        
        surahButton.backgroundColor = .primaryGreen
        surahButton.setTitleColor(.white, for: .normal)
        surahButton.layer.cornerRadius = 12
        surahButton.setTitle("Surah", for: .normal)
        
        juzButton.backgroundColor = .systemGray6
        juzButton.setTitleColor(.black, for: .normal)
        juzButton.layer.cornerRadius = 12
        juzButton.setTitle("Juz", for: .normal)
        
        [surahButton, juzButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.translatesAutoresizingMaskIntoConstraints = false
            tabStack.addArrangedSubview($0)
        }

        tabStack.axis = .horizontal
        tabStack.spacing = 8
        tabStack.distribution = .fillEqually
        
        textfieldIcon.image = UIImage(systemName: "magnifyingglass")
        textfieldIcon.tintColor = .systemGray2
        textfieldIcon.contentMode = .scaleAspectFit
        textfieldIcon.translatesAutoresizingMaskIntoConstraints = false
        textfieldLeftContainer.addSubview(textfieldIcon)
        textfieldLeftContainer.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.placeholder = "Cari nama atau nomor surah"
        searchTextField.font = .systemFont(ofSize: 16)
        searchTextField.backgroundColor = .systemGray6
        searchTextField.layer.cornerRadius = 12
        searchTextField.leftView = textfieldLeftContainer
        searchTextField.leftViewMode = .always
        searchTextField.clearButtonMode = .whileEditing
        
        infoIcon.image = UIImage(systemName: "info.circle")
        infoIcon.contentMode = .scaleAspectFit
        infoIcon.tintColor = .systemGray2
        
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .systemGray2
        infoLabel.numberOfLines = 0
        infoLabel.text = "Hanya satu target aktif dalam satu waktu."
        
        [infoIcon, infoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoHStack.addArrangedSubview($0)
        }
        
        infoHStack.axis = .horizontal
        infoHStack.spacing = 8
        infoHStack.alignment = .center
        infoHStack.distribution = .fill
        infoHStack.isHidden = true
        
        [topHStack, tabStack, searchTextField, infoHStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerVStack.addArrangedSubview($0)
        }
        
        headerVStack.axis = .vertical
        headerVStack.spacing = 16
        headerVStack.alignment = .fill
        headerVStack.distribution = .fill

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TargetPickerCell.self, forCellReuseIdentifier: TargetPickerCell.identifier)
        
        footerLine.backgroundColor = .separator
        
        footerDesc.font = .systemFont(ofSize: 13)
        footerDesc.textColor = .systemGray2
        footerDesc.textAlignment = .left
        footerDesc.numberOfLines = 0
        footerDesc.isHidden = true
        
        footerTitle.font = .systemFont(ofSize: 15, weight: .bold)
        footerTitle.textColor = .black
        footerTitle.textAlignment = .left
        footerTitle.numberOfLines = 0
        footerTitle.isHidden = true
        
        footerButton.isEnabled = false
        
        [footerTitle, footerDesc, footerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            footerVStack.addArrangedSubview($0)
        }
        
        footerVStack.axis = .vertical
        footerVStack.spacing = 16
        footerVStack.alignment = .fill
        footerVStack.distribution = .fill
        
        footerVStack.setCustomSpacing(4, after: footerTitle)
        
        [footerLine, footerVStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview($0)
        }

        [headerVStack, tableView, footerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerVStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            headerVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            tabStack.heightAnchor.constraint(equalToConstant: 44),
            
            textfieldLeftContainer.heightAnchor.constraint(equalToConstant: 24),
            textfieldLeftContainer.widthAnchor.constraint(equalToConstant: 48),
            textfieldIcon.heightAnchor.constraint(equalToConstant: 24),
            textfieldIcon.widthAnchor.constraint(equalToConstant: 24),
            textfieldIcon.centerYAnchor.constraint(equalTo: textfieldLeftContainer.centerYAnchor),
            textfieldIcon.centerXAnchor.constraint(equalTo: textfieldLeftContainer.centerXAnchor),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 56),

            tableView.topAnchor.constraint(equalTo: headerVStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            footerLine.heightAnchor.constraint(equalToConstant: 1),
            footerLine.topAnchor.constraint(equalTo: footerView.topAnchor),
            footerLine.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            footerLine.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            
            footerVStack.topAnchor.constraint(equalTo: footerLine.bottomAnchor, constant: 16),
            footerVStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 24),
            footerVStack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -24),
            footerVStack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            
            infoIcon.heightAnchor.constraint(equalToConstant: 16),
            infoIcon.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        closeButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        footerButton.addTarget(self, action: #selector(onSelectTapped), for: .touchUpInside)
        juzButton.addTarget(self, action: #selector(juzTapped), for: .touchUpInside)
        surahButton.addTarget(self, action: #selector(surahTapped), for: .touchUpInside)
    }
    
    func setData(_ target: TargetPickerCellEntity, descriptionHide: Bool = true) {
        previousData = target
        selectedData = target
        infoHStack.isHidden = descriptionHide
    }
    
    private func updateTabState() {
        let selectedColor = UIColor.primaryGreen
        let unselectedColor = UIColor.systemGray6
        
        switch selectedTab {
        case .juz:
            subtitleLabel.text = "Pilih juz yang ingin kamu hafal."
            searchTextField.placeholder = "Cari nomor juz"
            juzButton.backgroundColor = selectedColor
            surahButton.backgroundColor = unselectedColor
            juzButton.setTitleColor(.white, for: .normal)
            surahButton.setTitleColor(.black, for: .normal)
        case .surah:
            subtitleLabel.text = "Pilih surah yang ingin kamu hafal."
            searchTextField.placeholder = "Cari nama atau nomor surah"
            juzButton.backgroundColor = unselectedColor
            surahButton.backgroundColor = selectedColor
            juzButton.setTitleColor(.black, for: .normal)
            surahButton.setTitleColor(.white, for: .normal)
        }
        
        updateFilteredData()
    }
    
    private func updateFilteredData() {
        let keyword = searchTextField.text ?? ""
        
        switch selectedTab {
        case .juz:
            filteredData = originalJuzsData.map {
                return TargetPickerCellEntity(id: $0.id, title: "Juz \($0.number)", subtitle: "\($0.totalPage) halaman", targetNumber: $0.number, type: .juz, totalCount: $0.totalPage)
            }
        case .surah:
            filteredData = originalSurahsData.map {
                TargetPickerCellEntity(id: $0.id, title: $0.latinName, subtitle: "\($0.verseCount) ayat", targetNumber: $0.number, type: .surah, totalCount: $0.verseCount)
            }
        }
        
        if !keyword.isEmpty {
            filteredData = filteredData.filter {
                $0.title.localizedCaseInsensitiveContains(keyword) ||
                String($0.targetNumber).contains(keyword)
            }
        }
        
        tableView.reloadData()
    }
    
    private func updateButton() {
        if let selectedData, selectedData != previousData {
            footerButton.isEnabled = true
        } else {
            footerButton.isEnabled = false
        }
    }
    
    @objc private func onCloseTapped() {
        dismiss(animated: true) {[weak self] in
            guard let self else { return }
            selectedData = nil
            previousData = nil
            updateButton()
            onClose?()
        }
    }
    
    @objc private func searchTextChanged() {
        updateFilteredData()
    }
    
    @objc private func onSelectTapped() {
        guard let selectedData else { return }
        didSelect?(selectedData)
    }
    
    @objc private func juzTapped() {
        selectedTab = .juz
        updateTabState()
        updateButton()
        tableView.reloadData()
    }

    @objc private func surahTapped() {
        selectedTab = .surah
        updateTabState()
        updateButton()
        tableView.reloadData()
    }
}

extension TargetPickerBottomSheet {
    
    private func showAlert(targetModel: TargetModel) {
        let alert = GeneralAlert()
        let content = PopupAlertSetTarget()
        
        content.configure(targetModel)
        
        content.onClose = {
            alert.dismissAlert()
        }
        
        content.onRestart = {[weak self] in
            alert.dismissAlert()
            self?.restartTarget(targetModel: targetModel)
        }
        
        content.onContinue = {[weak self] in
            guard let self, let selectedData else { return }
            alert.dismissAlert()
            didSelect?(selectedData)
        }
        
        alert.setContent(content)

        alert.modalPresentationStyle = .overFullScreen
        present(alert, animated: false)
    }
    
    private func restartTarget(targetModel: TargetModel) {
        var newTarget = targetModel
        newTarget.completedVerseCount = 0
        newTarget.completedAt = nil
        
//        self.didSelect?(newTarget)
    }
    
    private func fetch() {
        let group = DispatchGroup()
        var errorFlow: Bool = false
        
        group.enter()
        let _ = ApiRequest.request(Endpoint.Surah.SurahList.url, method: .get, cacheable: true) {[weak self] result in
            defer { group.leave() }
            
            do {
                let response = try result.get() as [SurahListResponse]
                self?.originalSurahsData = response
            } catch {
                errorFlow = true
                print("Error: \(error)")
            }
        }
        
        group.enter()
        let _ = ApiRequest.request(Endpoint.Juz.JuzList.url, method: .get, cacheable: true) {[weak self] result in
            defer { group.leave() }
            
            do {
                let response = try result.get() as [JuzListResponse]
                self?.originalJuzsData = response
            } catch {
                errorFlow = true
                print("Error: \(error)")
            }
        }
        
        group.notify(queue: .main) {[weak self] in
            guard !errorFlow else {
                Snackbar.show(.error, "Sedang Terjadi Kendala")
                return
            }
            
            self?.updateFilteredData()
        }
    }
}

extension TargetPickerBottomSheet: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetPickerCell.identifier, for: indexPath) as! TargetPickerCell

        let item = filteredData[indexPath.item]
        cell.setConfigurasi(item)
        cell.isSelectedTarget = selectedData == item
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filteredData.count else { return }
        
        let item = filteredData[indexPath.item]
        
        if let userDailyTarget {
            footerTitle.text = "\(item.title) • \(item.subtitle)"
            footerTitle.isHidden = false
            
            let estimated = (item.totalCount + userDailyTarget - 1) / userDailyTarget
            footerDesc.text = "Estimasi selesai ± \(estimated) hari dengan \(item.subtitle) per hari"
            footerDesc.isHidden = false
        }
        
        selectedData = item
        updateButton()
        tableView.reloadData()
    }
}
