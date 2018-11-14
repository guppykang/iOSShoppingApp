//
//  RegisterViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/13/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController {
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
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let phoneNumberTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    let addressTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
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
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let address = addressTextField.text
            
            else {
                
                return
            }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            //if there are no errors, you try to sign in to authenticate that it is working
            print("\nAttempting to create a new user")
            if error != nil {
                // This signin function will trigger the listener in the didLoad function above. It will then segue into the table view
                let alert = UIAlertController(title: "Register Failed",
                                              message: error!.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Successful Registered New Account");
            }
            
            
            guard let uid = user?.user.uid else {
                return
            }
            
            
            let reference = Database.database().reference(fromURL: "https://groceryforuser-79e3b.firebaseio.com/")
            
            let userReference = reference.child("Users").child(uid)
            
            
            //TODO : Store user encryped version of the user password
            let newUserValues = ["name" : name, "phone number" : phoneNumber, "email" : email]
            
            //creating the initial first order for the user
            reference.child("ActiveOrders").child(uid).child("1").child("Time").setValue("TBD")
            let currentOrderPath = reference.child("ActiveOrders").child(uid).child("1").url

            //add the order to the currentOrder
            userReference.child("CurrentOrder").child("1").setValue(currentOrderPath)
            
            //add the order to the NewOrders
            userReference.child("NewOrders").child("1").setValue(currentOrderPath)
            
            userReference.child("Addresses").child("Default").setValue(address)
            userReference.child("Addresses").child("Counter").setValue(1)

            userReference.child("OrderCounter").setValue(1)
            
            userReference.updateChildValues(newUserValues, withCompletionBlock: {(newChildError, ref) in
                if (newChildError != nil){
                    print ("Error \(String(describing: newChildError))")
                    return
                }
                
                let mainPage = CustomTabBarController()
                self.present(mainPage, animated: true, completion: nil)
                
                print("Successful Register")
            }  )
            
        }//end auth
    }
    
    let signInLabel : UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let backToSignInButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        button.addTarget(self, action: #selector(handleBackToSignIn), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleBackToSignIn() {
        let vc = AuthenticationMenuViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(registerButton)
        view.addSubview(inputContainterView)
        view.addSubview(signInLabel)
        view.addSubview(backToSignInButton)
        view.addSubview(addressTextField)
        
        
        //title Label
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        //container view
        inputContainterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainterView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 100).isActive  = true
        inputContainterView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainterView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainterView.addSubview(nameTextField)
        inputContainterView.addSubview(phoneNumberTextField)
        inputContainterView.addSubview(usernameTextField)
        inputContainterView.addSubview(passwordTextField)
        
        //Name
        nameTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        nameTextField.topAnchor.constraint(equalTo: inputContainterView.topAnchor).isActive  = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/5).isActive  = true
        
        //Phone Number
        phoneNumberTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive  = true
        phoneNumberTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        phoneNumberTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/5).isActive  = true
        
        //address
        addressTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        addressTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor).isActive  = true
        addressTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        addressTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/5).isActive  = true
        
        //username text field
        usernameTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        usernameTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor).isActive  = true
        usernameTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        usernameTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/5).isActive  = true
        
        
        
        //password
        passwordTextField.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor, constant: 12).isActive  = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive  = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive  = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/5).isActive  = true
        
        //register button
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 400).isActive = true
        
        backToSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backToSignInButton.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 5).isActive = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()


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
