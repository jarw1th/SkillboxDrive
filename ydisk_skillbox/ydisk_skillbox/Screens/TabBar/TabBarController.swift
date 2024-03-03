//
//  TabBarController.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 01.03.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: LastUploadedViewController())
        let vc2 = UINavigationController(rootViewController: AllFilesViewController())
        let vc3 = UINavigationController(rootViewController: UIViewController())
        
        vc1.navigationBar.titleTextAttributes = [.foregroundColor: Constants.Colors.Accent1!]
        vc1.navigationBar.tintColor = Constants.Colors.Accent1
        
        vc1.title = "0"
        vc1.tabBarItem = UITabBarItem(title: "Title", image: UIImage(named: "pencil"), tag: 0)
        vc1.tabBarItem = UITabBarItem(title: "Title", image: UIImage(named: "house"), tag: 1)
        vc1.tabBarItem = UITabBarItem(title: "Title", image: UIImage(named: "eraser"), tag: 2)
        self.viewControllers = [vc1, vc2, vc3]
        self.selectedIndex = 0
        self.tabBar.isHidden = false
    }
}
