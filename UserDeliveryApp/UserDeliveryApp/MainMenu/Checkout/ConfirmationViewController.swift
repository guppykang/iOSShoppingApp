//
//  ConfirmationViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 11/14/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    let confirmLabel : UILabel = {
        let label = UILabel()
        label.text = "Order Confirmed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkMarkImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Checkmark")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let doneButton : UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Finish", for: .normal)
        doneButton.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    @objc func handleFinish() {
        let mainPage = CustomTabBarController()
        self.present(mainPage, animated: true, completion: nil)
        
    }
    func setupViews() {
        view.addSubview(confirmLabel)
        view.addSubview(checkMarkImageView)
        view.addSubview(doneButton)
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        checkMarkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkMarkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        confirmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmLabel.topAnchor.constraint(equalTo: checkMarkImageView.bottomAnchor, constant: 15).isActive = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupViews()
        // Do any additional setup after loading the view.
    }

}
