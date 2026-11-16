//
//  TargetsChangeBottomSheet.swift
//  Kuttaib
//
//  Created by mco on 16/11/26.
//

import UIKit

final class TargetsChangeBottomSheet: UIView {
    let title = UILabel()
    let subtitle = UILabel()
    
    let continueButton = PrimaryButton(title: "Aktifkan")
    let detailButton = PrimaryButton(title: "Lihat Detail")
    
    let contentVStack = UIStackView()
    
    var onContinueTapped: (() -> Void)?
    var onDetailTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        
        subtitle.font = .systemFont(ofSize: 13)
        subtitle.textColor = .systemGray2
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .left
        subtitle.text = "Kamu dapat melihat detail target ini atau beralih ke target ini. Mengaktifkan target ini akan menonaktifkan target yang sedang aktif tanpa menghapus progres yang telah dicapai."
        
        continueButton.setColor(.primaryGreen, titleColor: .white)
        detailButton.setColor(.white, titleColor: .primaryGreen)
        
        [title, subtitle, continueButton, detailButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.spacing = 24
        contentVStack.alignment = .fill
        contentVStack.distribution = .fill
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentVStack.setCustomSpacing(8, after: continueButton)
        
        addSubview(contentVStack)
        
        NSLayoutConstraint.activate([
            contentVStack.topAnchor.constraint(equalTo: topAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        continueButton.addTarget(self, action: #selector(onContinueButtonTapped), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(onDetailButtonTapped), for: .touchUpInside)
    }
    
    func setTitle(_ titleString: String) {
        title.text = titleString
    }
    
    @objc private func onContinueButtonTapped() {
        onContinueTapped?()
    }
    
    @objc private func onDetailButtonTapped() {
        onDetailTapped?()
    }
}
