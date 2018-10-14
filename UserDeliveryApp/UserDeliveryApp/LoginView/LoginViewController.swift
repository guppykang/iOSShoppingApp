//
//  LoginViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/13/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let inputContainterView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    private func setupLayout() {
        view.addSubview(inputContainterView)
        inputContainterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive  = true
        inputContainterView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainterView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        // Do any additional setup after loading the view.
        setupLayout()
    }
    


}
