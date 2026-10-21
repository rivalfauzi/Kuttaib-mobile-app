//
//  ConfirmTargetViewController.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import UIKit

final class ConfirmTargetViewController: BaseViewController {
    let presenter: ConfirmTargetPresenter
    
    private let topImage = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let nextButton = PrimaryButton(title: "Mulai Hari Ini")
    private let tableView = UITableView()
    private let vStack = UIStackView()
    
    init(presenter: ConfirmTargetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImage.contentMode = .scaleAspectFit
        let image = UIImage(named: "setTargetConfirm")
        let ratio = (image?.size.height ?? 1) / (image?.size.width ?? 1)
        topImage.image = image
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "Target Hafalan Siap!"
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textColor = .systemGray2
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = "Berikut adalah ringkasan targetmu. Kamu bisa mengubahnya nanti di pengaturan."
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConfirmTargetCell.self, forCellReuseIdentifier: ConfirmTargetCell.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        
        [topImage, titleLabel, descLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .center
        vStack.spacing = 24
        
        [vStack, tableView, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            topImage.heightAnchor.constraint(equalTo: topImage.widthAnchor, multiplier: ratio),
            
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            tableView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nextButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        presenter.onNextButtonTapped()
    }
}

extension ConfirmTargetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmTargetCell.identifier, for: indexPath) as! ConfirmTargetCell
        
        cell.configuration(presenter.data[indexPath.item])
        return cell
    }
}
