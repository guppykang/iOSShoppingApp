//
//  NewAddressViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 11/10/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase

class NewAddressViewController: UIViewController {

    let addressTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let addAddressButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Add Address", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleNewAddress), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    @objc func handleNewAddress() {
        let address : String!
        if addressTextField.text != "" {
            address = addressTextField.text
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Addresses").child("Counter").observeSingleEvent(of: .value) { (snapshot) in
                var currentAddressCount = snapshot.value as! Int
                
                
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Addresses").child(String(currentAddressCount)).setValue(address)
                
                currentAddressCount += 1
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Addresses").child("Counter").setValue(currentAddressCount)
            }
            
            navigationController?.popViewController(animated: true)
        }
        else {
            return
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        view.addSubview(addressTextField)
        view.addSubview(addAddressButton)
        
        addressTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addAddressButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
}
