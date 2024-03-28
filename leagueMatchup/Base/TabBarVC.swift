//
//  TabBarVC.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 16/02/24.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        let persistentContainer = sceneDelegate.getPersistentContainer()
        
        let home = UINavigationController(rootViewController: HomeVC(persistentContainer: persistentContainer))
        let matchups = UINavigationController(rootViewController: ListMatchupVC(persistentContainer: persistentContainer))
                
        setViewControllers([home, matchups], animated: false)
        tabBar.isTranslucent = false
        tabBar.tintColor = .clear
        
        tabBar.tintColor = UIColor.red
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "plus.diamond")
        items[1].image = UIImage(systemName: "folder")
    }
   
}
