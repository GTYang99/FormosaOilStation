//
//  MainTabBarController.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/16.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: MapVC())
        homeVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        let favoriteVC = UINavigationController(rootViewController: NearVC(title: "Favorite Stations", isNearShown: false))
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart.square"), tag: 1)
        
        let nearbyVC = UINavigationController(rootViewController: NearVC())
        nearbyVC.tabBarItem = UITabBarItem(title: "Near", image: UIImage(systemName: "signpost.right.and.left"), tag: 1)
        
        let searchVC = UINavigationController(rootViewController: UIViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Price", image: UIImage(systemName: "network"), tag: 2)
        viewControllers = [homeVC, favoriteVC, nearbyVC, searchVC]
        
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
