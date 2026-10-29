//
//  StepIndicatorView.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

final class StepIndicatorView: UIStackView {

    private var indicators: [UIView] = []

    var totalSteps: Int {
        indicators.count
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .horizontal
        spacing = 8
        distribution = .fill
        alignment = .center
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Public

    func updateTotalSteps(total: Int) {

        let currentTotal = indicators.count

        if total > currentTotal {

            appendSteps(total - currentTotal)

        } else if total < currentTotal {

            removeSteps(currentTotal - total)
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

    // MARK: - Private

    private func appendSteps(_ count: Int) {

        guard count > 0 else { return }

        for _ in 0..<count {

            let indicator = makeIndicator()

            indicator.alpha = 0
            indicator.transform = CGAffineTransform(
                scaleX: 0.7,
                y: 0.7
            )

            addArrangedSubview(indicator)
            indicators.append(indicator)

            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: .curveEaseOut
            ) {
                indicator.alpha = 1
                indicator.transform = .identity
            }
        }
    }

    private func removeSteps(_ count: Int) {

        guard count > 0 else { return }

        for _ in 0..<count {

            guard let lastIndicator = indicators.popLast() else {
                return
            }

            UIView.animate(
                withDuration: 0.2,
                animations: {
                    lastIndicator.alpha = 0
                    lastIndicator.transform =
                        CGAffineTransform(scaleX: 0.7, y: 0.7)
                },
                completion: { _ in
                    self.removeArrangedSubview(lastIndicator)
                    lastIndicator.removeFromSuperview()
                }
            )
        }
    }

    private func makeIndicator() -> UIView {

        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 20),
            view.heightAnchor.constraint(equalToConstant: 8)
        ])

        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4

        return view
    }
}
