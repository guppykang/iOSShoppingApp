//
//  CheckoutCollectionViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 11/7/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase


var addresses : [String] = []
var phoneNumber : String = ""

var selectedAddressIndex = 0;

class CheckoutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0
        
        if pickerView.tag == 0 {
            count = addresses.count
        }
        return count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String!
        
        if pickerView.tag == 0 {
            title = addresses[row]
        }
        return title

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            selectedAddressIndex = row
        }
        
    }

    private let reuseIdentifier = "Cell"
    let blackView = UIView()
    
    //address cell
    var addressPickerView = UIPickerView()

    var subMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    @objc func handleNewAddress() {
        handleDismiss()
        let vc = NewAddressViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getAddresses() {
        addresses = []
        //get the address of the users
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Addresses").observeSingleEvent(of: .value) { (addressesSnapshot) in
            let enumerator = addressesSnapshot.children
            
            while let addressSnapshot = enumerator.nextObject() as? DataSnapshot {
                if addressSnapshot.key != "Counter" {
                    let address = (addressSnapshot.value as? String)!
                    addresses.append(address)
                    
                    
                }
                DispatchQueue.main.async(execute: {
                    let defaultAddress = addresses.remove(at: addresses.count-1)
                    addresses.insert(defaultAddress, at: 0)
                    self.addressPickerView.reloadAllComponents()
                    self.collectionView.reloadData()
                })
                
                
            }
            
        }
        
        
        
    }
    
    func getPhoneNumbers() {
        
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("phone number").observeSingleEvent(of: .value) { (phoneNumberSnapshot) in
            print("HIIIIIIII")
            phoneNumber = phoneNumberSnapshot.value as! String
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                
            })
            
        }
    }
    func presentSubMenu(index : Int) {
        //the address cell
        if index == 0 {
            getAddresses()

            subMenu = UIView()
            subMenu.backgroundColor = .white
            
            addressPickerView.translatesAutoresizingMaskIntoConstraints = false
            addressPickerView.delegate = self
            addressPickerView.dataSource = self
            
            addressPickerView.tag = 0
            
            let newAddressButton : UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("New", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                button.setTitleColor(.black, for: .normal)
                
                button.addTarget(self, action: #selector(handleNewAddress), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            let doneButton : UIButton = {
                let doneButton = UIButton(type: .system)
                doneButton.setTitle("Done", for: .normal)
                doneButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
                doneButton.translatesAutoresizingMaskIntoConstraints = false
                return doneButton
            }()
            
            
            
            subMenu.addSubview(newAddressButton)
            subMenu.addSubview(addressPickerView)
            subMenu.addSubview(doneButton)
            
            addressPickerView.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            addressPickerView.topAnchor.constraint(equalTo: subMenu.topAnchor).isActive = true
            
            doneButton.leftAnchor.constraint(equalTo: subMenu.leftAnchor, constant: 20).isActive = true
            doneButton.topAnchor.constraint(equalTo: subMenu.topAnchor, constant: 5).isActive = true
            
            newAddressButton.rightAnchor.constraint(equalTo: subMenu.rightAnchor, constant: -20).isActive = true
            newAddressButton.topAnchor.constraint(equalTo: subMenu.topAnchor, constant: 5).isActive = true
            
        }
        //This is the delivery time
        else if index == 1 {
            getPhoneNumbers()
            subMenu = UIView()
            subMenu.backgroundColor = .red
            
            
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
        defaultAddressLabel.text = addresses[selectedAddressIndex]
        UIView.animate(withDuration: 0.25) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.subMenu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)

            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAddresses()
        getPhoneNumbers()
        collectionView.backgroundColor = .white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        navigationItem.title = "Checkout"
        // Register cell classes
        self.collectionView!.register(CheckoutCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    let defaultAddressLabel = UILabel()
    let defaultPhoneNumber = UILabel()
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CheckoutCell
        
        if(indexPath.item == 0) {
            print("Location")
            if addresses.count > 0 {
                
                defaultAddressLabel.text = addresses[selectedAddressIndex]
                defaultAddressLabel.translatesAutoresizingMaskIntoConstraints = false
            
                let image = UIImageView()
                image.image = UIImage(named: "LocationPin")
                image.translatesAutoresizingMaskIntoConstraints = false
                
                

            
                cell?.addSubview(defaultAddressLabel)
                cell?.addSubview(image)
                
                defaultAddressLabel.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
                defaultAddressLabel.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                
                image.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                image.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            }
            
        }
        else if indexPath.item == 1 {
            print("Phone: \(phoneNumber)")
            if phoneNumber != "" {
                defaultPhoneNumber.text = phoneNumber
                defaultPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
            
                let image = UIImageView()
                image.image = UIImage(named: "CheckoutPhone")
                image.translatesAutoresizingMaskIntoConstraints = false
            
                cell?.addSubview(image)
                cell?.addSubview(defaultPhoneNumber)
            
                defaultPhoneNumber.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
                defaultPhoneNumber.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true

                image.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                image.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            }
        }
        else {
            print("hi mom")
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentSubMenu(index : indexPath.item)
    }

}

class CheckoutCell : UICollectionViewCell {
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray	
        return view
    }()
    
    let arrow : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Arrow")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(dividerLineView)
        addSubview(arrow)
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 10).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
    }
}

//class CustomAddressPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return addresses.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return addresses[row]
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedAddressIndex = row
//    }
//
//}
