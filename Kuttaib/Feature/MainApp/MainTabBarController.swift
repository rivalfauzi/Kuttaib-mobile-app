//
//  MainTabBarController.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    let coordinator: MainAppCoordinator
    
    init(coordinator: MainAppCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .primaryGreen
        tabBar.unselectedItemTintColor = .lightGray

        setupTabs()
    }

    private func setupTabs() {
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator.start()

        homeNav.tabBarItem = UITabBarItem(
            title: "Beranda",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let profileNav = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        profileCoordinator.start()
        
        profileNav.tabBarItem = UITabBarItem(
            title: "Profil",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            homeNav,
            profileNav
        ]
    }
}
