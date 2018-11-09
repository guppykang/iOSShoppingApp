//
//  CheckoutCollectionViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 11/7/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit


class CheckoutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return
//
//    }
//

    private let reuseIdentifier = "Cell"
    let blackView = UIView()
    var addresses : [String] = []
    
    var subMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    @objc func handleNewAddress() {
        print("Hi mom")
    }
    
    
    func getAddresses() {
        //get the address of the users
    }
    func presentSubMenu(index : Int) {
        //the address cell
        if index == 0 {
            subMenu = UIView()
            subMenu.backgroundColor = .green
            
            getAddresses()
            var pickerView = UIPickerView()
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            pickerView.delegate = self
            pickerView.dataSource = self
            
            let newAddressButton : UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("New", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                button.setTitleColor(.black, for: .normal)
                
                button.addTarget(self, action: #selector(handleNewAddress), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            
            subMenu.addSubview(newAddressButton)
            subMenu.addSubview(pickerView)
            
            pickerView.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            pickerView.topAnchor.constraint(equalTo: subMenu.topAnchor).isActive = true
            
            newAddressButton.rightAnchor.constraint(equalTo: subMenu.rightAnchor, constant: -20).isActive = true
            newAddressButton.topAnchor.constraint(equalTo: subMenu.topAnchor, constant: 5).isActive = true
            
        }
        //This is the delivery time
        else if index == 1 {
            subMenu = UIView()
            subMenu.backgroundColor = .red
            
            let timeSlot1 : UILabel = {
                let label = UILabel()
                label.text = "9AM - 10AM"
                
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            
            subMenu.addSubview(timeSlot1)
            
            timeSlot1.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            timeSlot1.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            
        }
        //this is the phone number TODO : EVENTUALLY CHANGE THIS TO AN IN APP MESSAGING SYSTEM
        else if index == 2 {
            subMenu = UIView()
            subMenu.backgroundColor = .purple
            
            let phoneNumber : UILabel = {
                let label = UILabel()
                label.text = "(858)519-6111"
                
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            
            subMenu.addSubview(phoneNumber)
            
            phoneNumber.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            phoneNumber.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            
        }
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(subMenu)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            subMenu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)
            
            
            UIView.animate(withDuration: 0.25) {
                self.blackView.alpha = 1
                self.subMenu.frame = CGRect(x: 0, y: window.frame.height-200, width: window.frame.width, height: 200)
            }
        }
        
        
        
        

    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.25) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.subMenu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)

            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(CheckoutCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CheckoutCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentSubMenu(index : indexPath.item)
    }

}

class CheckoutCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .gray
    }
}
