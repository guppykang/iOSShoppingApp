//
//  AuthenticationMenuViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/11/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class AuthenticationMenuViewController: UIViewController {

    //Title
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "CART"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //login button
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLoginButton() {
        let vc = LoginViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    //Register Button
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleRegisterButton() {
        let vc = RegisterViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        //title Label
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        //login button
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 150).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        
        //register button
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
        
    }
    

    

}
