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

        let vc1 = UINavigationController(rootViewController: ProfileViewController())
        let vc2 = UINavigationController(rootViewController: LastUploadedViewController())
        let vc3 = UINavigationController(rootViewController: AllFilesViewController(path: "disk:/"))
        
        vc1.navigationBar.titleTextAttributes = [.foregroundColor: Constants.Colors.Accent1!]
        vc1.navigationBar.tintColor = Constants.Colors.Accent1
        vc2.navigationBar.titleTextAttributes = [.foregroundColor: Constants.Colors.Accent1!]
        vc2.navigationBar.tintColor = Constants.Colors.Accent1
        vc3.navigationBar.titleTextAttributes = [.foregroundColor: Constants.Colors.Accent1!]
        vc3.navigationBar.tintColor = Constants.Colors.Accent1
        
        let item1 = UITabBarItem()
        let item2 = UITabBarItem()
        let item3 = UITabBarItem()
        
        item1.title = "Профиль"
        item2.title = Constants.Texts.titleLastUploadedScreen
        item3.title = Constants.Texts.titleAllFilesScreen
        
        item1.tag = 0
        item1.tag = 1
        item1.tag = 2
        
        item1.setTitleTextAttributes([.foregroundColor: Constants.Colors.Icons!], for: .normal)
        item1.setTitleTextAttributes([.foregroundColor: Constants.Colors.Accent1!], for: .selected)
        item2.setTitleTextAttributes([.foregroundColor: Constants.Colors.Icons!], for: .normal)
        item2.setTitleTextAttributes([.foregroundColor: Constants.Colors.Accent1!], for: .selected)
        item3.setTitleTextAttributes([.foregroundColor: Constants.Colors.Icons!], for: .normal)
        item3.setTitleTextAttributes([.foregroundColor: Constants.Colors.Accent1!], for: .selected)
        
        item1.image = UIImage(systemName: "person.fill")?.withTintColor(Constants.Colors.Icons!)
        item1.selectedImage = UIImage(systemName: "person.fill")?.withTintColor(Constants.Colors.Accent1!)
        item2.image = UIImage(systemName: "doc.fill")?.withTintColor(Constants.Colors.Icons!)
        item2.selectedImage = UIImage(systemName: "doc.fill")?.withTintColor(Constants.Colors.Accent1!)
        item3.image = UIImage(systemName: "archive.fill")?.withTintColor(Constants.Colors.Icons!)
        item3.selectedImage = UIImage(systemName: "archive.fill")?.withTintColor(Constants.Colors.Accent1!)
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        
        self.viewControllers = [vc1, vc2, vc3]
        self.selectedIndex = 1
        self.tabBar.isHidden = false
    }
}
