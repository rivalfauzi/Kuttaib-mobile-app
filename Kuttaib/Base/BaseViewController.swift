//
//  BaseViewController.swift
//  Kuttaib
//
//  Created by mco on 12/10/26.
//

import UIKit

class BaseViewController: UIViewController {
    private var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .warmBackground
    }
    
    func showLoading() {
        guard loadingView == nil else { return }

        let loadingView = LoadingView(frame: view.bounds)
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        self.loadingView = loadingView
    }

    func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
