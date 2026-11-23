//
//  Snackbar.swift
//  Kuttaib
//
//  Created by mco on 20/11/26.
//

import UIKit

final class Snackbar {

    static func show(_ type: SnackbarType, _ message: String, duration: TimeInterval = 2.0) {

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            return
        }

        let snackbar = SnackbarView(
            type: type,
            message: message
        )

        snackbar.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(snackbar)

        let topConstraint = snackbar.topAnchor.constraint(
            equalTo: window.safeAreaLayoutGuide.topAnchor,
            constant: -100
        )

        NSLayoutConstraint.activate([
            topConstraint,

            snackbar.leadingAnchor.constraint(
                equalTo: window.leadingAnchor,
                constant: 16
            ),

            snackbar.trailingAnchor.constraint(
                equalTo: window.trailingAnchor,
                constant: -16
            )
        ])

        window.layoutIfNeeded()

        // SHOW
        topConstraint.constant = 12

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            window.layoutIfNeeded()
        }

        // HIDE
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {

            topConstraint.constant = -100

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseIn]
            ) {
                window.layoutIfNeeded()
            } completion: { _ in
                snackbar.removeFromSuperview()
            }
        }
    }
}
