//
//  ChangeReminderBottomSheet.swift
//  Kuttaib
//
//  Created by mco on 17/11/26.
//

import UIKit

final class ChangeReminderBottomSheet: UIView {
    private let title = UILabel()
    private let subtitle = UILabel()
    private let datePicker = UIDatePicker()
    private let saveButton = PrimaryButton(title: "Simpan")
    private let closeButton = PrimaryButton(title: "Batal")
    private let mainVStack = UIStackView()
    
    var onSave: ((ReminderSetting) -> Void)?
    var onClose: (() -> Void)?
    
    var reminderData: ReminderSetting?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 21, weight: .bold)
        title.textColor = .black
        title.text = "Waktu Pengingat"
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .systemGray2
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        subtitle.text = "Kapan kamu ingin diingatkan untuk fokus menghafal?"
        
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        saveButton.setColor(.primaryGreen, titleColor: .white)
        closeButton.setColor(.white, titleColor: .primaryGreen)
        
        [title, subtitle, datePicker, saveButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainVStack.addArrangedSubview($0)
        }
        
        mainVStack.axis = .vertical
        mainVStack.spacing = 16
        mainVStack.alignment = .fill
        mainVStack.distribution = .fill
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    func configure(_ data: ReminderSetting) {
        reminderData = data
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = data.hour
        components.minute = data.minute

        if let date = Calendar.current.date(from: components) {
            datePicker.date = date
        }
    }
    
    @objc private func saveTapped() {
        guard var reminderData else { return }
        let date = datePicker.date

        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: date
        )

        reminderData.hour = components.hour ?? 0
        reminderData.minute = components.minute ?? 0
        
        onSave?(reminderData)
    }
    
    @objc private func closeTapped() {
        onClose?()
    }
}
