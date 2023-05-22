//
//  ViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 22.05.2023.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        let characterViewController = RMCharacterViewController()
        let locationViewController = RMLocationViewController()
        let episodeViewController = RMEpisodeViewController()
        let settingsViewController = RMSettingsViewController()
        
        characterViewController.navigationItem.largeTitleDisplayMode = .automatic
        locationViewController.navigationItem.largeTitleDisplayMode = .automatic
        episodeViewController.navigationItem.largeTitleDisplayMode = .automatic
        settingsViewController.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: characterViewController)
        let nav2 = UINavigationController(rootViewController: locationViewController)
        let nav3 = UINavigationController(rootViewController: episodeViewController)
        let nav4 = UINavigationController(rootViewController: settingsViewController)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }

}

