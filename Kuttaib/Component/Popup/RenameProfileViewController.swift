//
//  RenameProfileViewController.swift
//  Kuttaib
//
//  Created by mco on 05/11/26.
//


import UIKit

final class RenameProfileViewController: UIViewController {

    var onSave: ((String) -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let fieldTitleLabel = UILabel()
    private let textFieldContainer = UIView()
    private let textField = UITextField()
    private let helperLabel = UILabel()
    private let counterLabel = UILabel()
    private let cancelButton = PrimaryButton(title: "Batal")
    private let saveButton = PrimaryButton(title: "Simpan")
    private let mainVStack = UIStackView()
    
    private let maxCharacter = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        titleLabel.text = "Ubah Nama"
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        titleLabel.textColor = .black
        
        subtitleLabel.text = "Nama ini dipakai untuk sapaan di Beranda."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2
        
        fieldTitleLabel.text = "Nama"
        fieldTitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        fieldTitleLabel.textColor = .black
        
        textField.placeholder = "Nama Pengguna"
        textField.font = .systemFont(ofSize: 18)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        textFieldContainer.layer.cornerRadius = 20
        textFieldContainer.layer.borderWidth = 2
        textFieldContainer.layer.borderColor = UIColor.primaryGreen.cgColor
        textFieldContainer.addSubview(textField)

        helperLabel.text = "Gunakan nama panggilanmu."
        helperLabel.font = .systemFont(ofSize: 12)
        helperLabel.textColor = .systemGray2

        counterLabel.font = .systemFont(ofSize: 12)
        counterLabel.textColor = .systemGray2
        
        cancelButton.setColor(.systemGray5, titleColor: .primaryGreen)
        cancelButton.setHeight(52)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        saveButton.setHeight(52)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let buttonStack = UIStackView()
        [cancelButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview($0)
        }

        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 12
        
        let helperStack = UIStackView()
        [helperLabel, UIView(), counterLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            helperStack.addArrangedSubview($0)
        }

        helperStack.axis = .horizontal
        
        [titleLabel, subtitleLabel, fieldTitleLabel, textFieldContainer, helperStack, buttonStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 24
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainVStack.setCustomSpacing(4, after: titleLabel)
        mainVStack.setCustomSpacing(8, after: fieldTitleLabel)
        mainVStack.setCustomSpacing(8, after: textFieldContainer)
        
        view.addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant: 52),

            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setUsername(_ name: String) {
        textField.text = name
        textChanged()
    }
    
    @objc func textChanged() {
        let count = textField.text?.count ?? 0
        counterLabel.text = "\(count)/24"
        saveButton.isEnabled = count > 0
        saveButton.alpha = count > 0 ? 1 : 0.5
    }

    @objc func cancelTapped() {
        dismiss(animated: true)
    }

    @objc func saveTapped() {
        guard let text = textField.text,
              !text.isEmpty else {
            return
        }

        onSave?(text)
        dismiss(animated: true)
    }
}

extension RenameProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        return updatedText.count <= maxCharacter
    }
}
