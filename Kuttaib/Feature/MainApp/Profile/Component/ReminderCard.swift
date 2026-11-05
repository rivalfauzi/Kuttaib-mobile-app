//
//  ReminderCard.swift
//  Kuttaib
//
//  Created by mco on 03/11/26.
//

import UIKit
import SkeletonView

final class ReminderCard: UIView {
    private let title = UILabel()
    
    private let contentView = UIView()
    private let contentVStack = UIStackView()
    
    private let iconView = UIIconView()
    private let titleLabel = UILabel()
    private let reminderSwitch = UISwitch()
    private let topHStack = UIStackView()
    private let separator = UIView()
    private let timeContainer = TimeContainer()
    private let reminderDays = ReminderDaysView()
    
    var onNeedNotificationPermission: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isSkeletonable = true
        
        title.text = "Pengingat Hafalan"
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textAlignment = .left
        
        iconView.configure(iconImage: UIImage(systemName: "clock"), iconTintColor: .primaryGold, background: .backgroundGold)
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.text = "Ingatkan Saya"
        
        reminderSwitch.onTintColor = .primaryGreen
        
        [iconView, titleLabel, reminderSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topHStack.addArrangedSubview($0)
        }
        
        topHStack.axis = .horizontal
        topHStack.spacing = 16
        topHStack.alignment = .center
        topHStack.distribution = .fill
        
        separator.backgroundColor = .separator
        
        [topHStack, separator, timeContainer, reminderDays].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.spacing = 16
        contentVStack.alignment = .fill
        contentVStack.distribution = .fill
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentVStack)
        
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .white
        contentView.skeletonCornerRadius = 24
        contentView.isSkeletonable = true
        
        [title, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        timeContainer.configure("5:30")
        timeContainer.onButtonTapped = {
            print("ubah pengingat")
        }
        
        reminderSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        if reminderSwitch.isOn {
            onNeedNotificationPermission?()
        } else {
            updateReminderState(isEnabled: false)
        }
    }
    
    private func updateReminderState(isEnabled: Bool) {
        timeContainer.alpha = isEnabled ? 1 : 0.5
        reminderDays.alpha = isEnabled ? 1 : 0.5

        timeContainer.isUserInteractionEnabled = isEnabled
        reminderDays.isUserInteractionEnabled = isEnabled
    }
    
    func configure(_ data: ReminderSetting) {
        reminderSwitch.isOn = data.isEnabled
        let time = String(format: "%02d:%02d", data.hour, data.minute)
        timeContainer.configure(time)
        
        reminderDays.configure(days: data.selectedDays)
        
        updateReminderState(isEnabled: reminderSwitch.isOn)
    }
    
    func updateSwitch(isOn: Bool) {
        reminderSwitch.setOn(isOn, animated: true)
        updateReminderState(isEnabled: isOn)
    }
}

final class TimeContainer: UIView {
    private let label = UILabel()
    private let value = UILabel()
    private let leftVStack = UIStackView()
    private let rightButton = UIButton()
    private let buttonViewContainer = UIView()
    private let mainHStack = UIStackView()
    
    var onButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 16
        backgroundColor = .goldAccent.withAlphaComponent(0.12)
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.text = "Waktu pengingat"
        
        value.font = .systemFont(ofSize: 22, weight: .bold)
        value.textColor = .black
        
        [label, value].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            leftVStack.addArrangedSubview($0)
        }
        
        leftVStack.axis = .vertical
        leftVStack.spacing = 4
        leftVStack.alignment = .fill
        leftVStack.distribution = .fill
        
        var config = UIButton.Configuration.plain()
        
        var attributes = AttributeContainer()
        attributes.font = .systemFont(ofSize: 16, weight: .semibold)
        
        config.attributedTitle = AttributedString("Ubah", attributes: attributes)
        config.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
        config.imagePlacement = .trailing
        config.imagePadding = 6

        rightButton.configuration = config
        rightButton.tintColor = .primaryGreen
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonViewContainer.addSubview(rightButton)
        
        [leftVStack, UIView(), buttonViewContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainHStack.addArrangedSubview($0)
        }
        
        mainHStack.axis = .horizontal
        mainHStack.spacing = 4
        mainHStack.alignment = .center
        mainHStack.distribution = .fill
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainHStack)
        
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            rightButton.topAnchor.constraint(equalTo: buttonViewContainer.topAnchor, constant: 8),
            rightButton.leadingAnchor.constraint(equalTo: buttonViewContainer.leadingAnchor, constant: 4),
            rightButton.trailingAnchor.constraint(equalTo: buttonViewContainer.trailingAnchor, constant: -4),
            rightButton.bottomAnchor.constraint(equalTo: buttonViewContainer.bottomAnchor, constant: -8),
        ])
        
        rightButton.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
    }
    
    func configure(_ time: String) {
        value.text = time
    }
    
    @objc private func onTapped() {
        onButtonTapped?()
    }
}

final class ReminderDaysView: UIView {
    private let title = UILabel()
    private let stackView = UIStackView()

    var selectedDays: Set<Weekday> = Set(Weekday.allCases)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        title.font = .systemFont(ofSize: 14)
        title.textColor = .systemGray2
        title.text = "Ulangi pada hari"
        title.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        Weekday.allCases.forEach { day in
            let button = DayButton()
            button.configure(day: day, isSelected: selectedDays.contains(day))
            button.addTarget(self, action: #selector(dayTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 42).isActive = true

            stackView.addArrangedSubview(button)
        }
    }

    @objc private func dayTapped(_ sender: DayButton) {
        guard let day = sender.day else { return }
        sender.isSelected.toggle()
        
        if sender.isSelected {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    func configure(days: [Weekday]) {
        let selectedWeekdays = Set(days)
        selectedDays.removeAll()

        stackView.arrangedSubviews.forEach {
            guard let button = $0 as? DayButton,
                  let day = button.day else {
                return
            }

            let isSelected = selectedWeekdays.contains(day)
            button.isSelected = isSelected
            if isSelected {
                selectedDays.insert(day)
            }
        }
    }
}

final class DayButton: UIButton {

    private(set) var day: Weekday?

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )

        layer.cornerRadius = 12

        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(day: Weekday, isSelected: Bool) {
        self.day = day
        self.isSelected = isSelected

        setTitle(day.title, for: .normal)

        updateAppearance()
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = .primaryGreen
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .systemGray6
            setTitleColor(.systemGray, for: .normal)
        }
    }
}
