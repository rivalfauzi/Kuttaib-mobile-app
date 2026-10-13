//
//  StepIndicatorView.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

final class StepIndicatorView: UIStackView {

    private var indicators: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        spacing = 8
        distribution = .fill
    }

    required init(coder: NSCoder) {
        fatalError()
    }
    
    func updateTotalSteps(total: Int) {
        for _ in 0..<total {

            let view = UIView()
            
            view.widthAnchor.constraint(
                equalToConstant: 20
            ).isActive = true

            view.heightAnchor.constraint(
                equalToConstant: 8
            ).isActive = true

            view.backgroundColor = .systemGray5
            view.layer.cornerRadius = 4
            
            addArrangedSubview(view)
            indicators.append(view)
        }
    }

    func update(step: Int) {

        for (index, indicator) in indicators.enumerated() {

            indicator.backgroundColor =
                index <= step
                ? .primaryGreen
                : .systemGray5
        }
    }
}
