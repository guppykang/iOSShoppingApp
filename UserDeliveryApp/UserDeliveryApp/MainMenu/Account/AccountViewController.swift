//
//  AccountViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/24/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    let logoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.red, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogoutButton), for: .touchUpInside)

        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    @objc func handleLogoutButton() {
        try! Auth.auth().signOut()
        
        let vc = AuthenticationMenuViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    func setupViews() {
        view.addSubview(logoutButton)
        
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Account"
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    
    

  

}
