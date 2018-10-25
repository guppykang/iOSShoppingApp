//
//  AuthenticationMenuViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/11/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class AuthenticationMenuViewController: UIViewController {
    
    
    //Title
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "CART"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //Container view
    let inputContainterView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    //text field for Username and password
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        //make sure that the login and password text Fields are not empty
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text,
            email.count >= 0,
            password.count >= 0
            else {
                print("invalid user or ID")
                return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let mainPage = CustomTabBarController()
                self.present(mainPage, animated: true, completion: nil)
                
                print("Successful Login")
                
            }
        }
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
        view.addSubview(inputContainterView)

        
        //title Label
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        //container view
        inputContainterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainterView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 100).isActive  = true
        inputContainterView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainterView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputContainterView.addSubview(usernameTextField)
        inputContainterView.addSubview(passwordTextField)
        
        //username text field
        usernameTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        usernameTextField.topAnchor.constraint(equalTo: inputContainterView.topAnchor).isActive  = true
        usernameTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        usernameTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/2).isActive  = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive  = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/2).isActive  = true
        
        //login button
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputContainterView.bottomAnchor, constant: 10).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        
        //register button
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
       
        
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        navigationItem.title = "Sign In"
        if Auth.auth().currentUser != nil {
            
            let mainPage = CustomTabBarController()
            self.present(mainPage, animated: true, completion: nil)
            
        }
        
        view.backgroundColor = .white
        setupLayout()
        
       
        
    }
    
    
    

    

}
