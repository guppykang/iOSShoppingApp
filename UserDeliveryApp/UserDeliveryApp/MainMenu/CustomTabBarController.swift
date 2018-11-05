//
//  CustomTabBarController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/24/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let navBar : UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        //HOME VIEW CONTROLLER
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let homeViewController = HomeViewController(collectionViewLayout : layout)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.title = "Home"
        navigationController.tabBarItem.image = UIImage(named: "HomeIcon")
        
        let accountViewController = AccountViewController()
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        accountNavigationController.title = "Account"
        accountNavigationController.tabBarItem.image = UIImage(named: "AccountIcon")
        
        viewControllers = [navigationController, accountNavigationController]
        
    }
    


}
