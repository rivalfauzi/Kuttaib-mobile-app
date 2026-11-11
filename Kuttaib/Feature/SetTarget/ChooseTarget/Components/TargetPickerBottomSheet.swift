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
    
    var didSelect: ((Quran.Surah.Response) -> Void)?
    var onClose: (() -> Void)?
    
    var userDailyTarget: Int?
    var originalData: [Quran.Surah.Response] = []
    private var filteredData: [Quran.Surah.Response] = []
    private var selectedData: Quran.Surah.Response?
    private var previousData: Quran.Surah.Response?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
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
        infoHStack.isHidden = selectedData == nil
        
        [topHStack, searchTextField, infoHStack].forEach {
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
    }
    
    func setData(_ data: [Quran.Surah.Response], selectedNumber: Int? = nil) {
        originalData = data
        filteredData = data
        
        if let selectedNumber {
            previousData = data.first {
                $0.number == selectedNumber
            }
            selectedData = previousData
        }
    }
    
    private func updateButton() {
        if let selectedData, selectedData.number != previousData?.number {
            footerButton.isEnabled = true
        } else {
            footerButton.isEnabled = false
        }
    }
    
    @objc private func onCloseTapped() {
        dismiss(animated: true) {[weak self] in
            self?.onClose?()
        }
    }
    
    @objc private func searchTextChanged() {
        let keyword = searchTextField.text ?? ""

        if keyword.isEmpty {
            filteredData = originalData
        } else {
            filteredData = originalData.filter {
                $0.englishName.localizedCaseInsensitiveContains(keyword) ||
                String($0.number).contains(keyword)
            }
        }

        tableView.reloadData()
    }
    
    @objc private func onSelectTapped() {
        guard let selectedData else { return }
        
        dismiss(animated: true) {[weak self] in
            self?.didSelect?(selectedData)
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
        cell.isSelectedTarget = selectedData?.number == item.number
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filteredData.count else { return }
        
        let item = filteredData[indexPath.item]
        
        if let userDailyTarget {
            footerTitle.text = "\(item.englishName) • \(item.numberOfAyahs) ayat"
            footerTitle.isHidden = false
            
            let estimated = (item.numberOfAyahs + userDailyTarget - 1) / userDailyTarget
            footerDesc.text = "Estimasi selesai ± \(estimated) hari dengan \(userDailyTarget) ayat per hari"
            footerDesc.isHidden = false
        }
        
        selectedData = item
        updateButton()
        tableView.reloadData()
    }
}

final class TargetPickerCell: UITableViewCell {
    static let identifier = "TargetPickerCell"
    
    private let indexLabel = UILabel()
    private let indexBackground = UIView()
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let centerVStack = UIStackView()
    
    private let rightImage = UIImageView()
    private let mainHStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var isSelectedTarget = false {
        didSet {
            updateView()
        }
    }

    private func setupView() {
        indexLabel.font = .systemFont(ofSize: 15, weight: .bold)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        indexBackground.addSubview(indexLabel)
        indexBackground.layer.cornerRadius = 12
        
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .systemGray2
        subtitle.textAlignment = .left
        
        [title, subtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            centerVStack.addArrangedSubview($0)
        }
        
        centerVStack.axis = .vertical
        centerVStack.spacing = 4
        centerVStack.alignment = .fill
        centerVStack.distribution = .fill
        
        rightImage.contentMode = .scaleAspectFit
        
        [indexBackground, centerVStack, rightImage].forEach {
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
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            indexBackground.heightAnchor.constraint(equalToConstant: 40),
            indexBackground.widthAnchor.constraint(equalToConstant: 40),
            
            indexLabel.centerXAnchor.constraint(equalTo: indexBackground.centerXAnchor),
            indexLabel.centerYAnchor.constraint(equalTo: indexBackground.centerYAnchor),
            
            rightImage.heightAnchor.constraint(equalToConstant: 24),
            rightImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setConfigurasi(_ item: Quran.Surah.Response) {
        indexLabel.text = "\(item.number)"
        title.text = item.englishName
        subtitle.text = "\(item.numberOfAyahs) ayat"
    }
    
    private func updateView() {
        if isSelectedTarget {
            contentView.backgroundColor = .backgroundGreen
            indexLabel.textColor = .white
            indexBackground.backgroundColor = .primaryGreen
            rightImage.image = UIImage(systemName: "checkmark.circle.fill")
            rightImage.tintColor = .primaryGreen
        } else {
            contentView.backgroundColor = .white
            indexLabel.textColor = .systemGray2
            indexBackground.backgroundColor = .systemGray5
            rightImage.image = UIImage(systemName: "circle")
            rightImage.tintColor = .systemGray2
        }
    }
}
