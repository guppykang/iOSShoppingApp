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
var times : [String] = ["Select", "9AM - 10AM", "10AM - 11AM", "11AM - 12PM", "12PM - 1PM", "2PM - 3PM", "4PM - 5PM", "5PM - 6PM"]

var selectedAddressIndex = 0;
var selectedTime = 0;

class CheckoutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var cart : [Item] = []
    var quantities : [String] = []
    
    let payButton : UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("PAY", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        doneButton.setTitleColor(.green, for: .normal)
        
        
        doneButton.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    @objc func handlePay() {
        
        //RIX TODO : check to make sure a valid card is saved and ready to use
        //stripe api call to charge the amount and all the other magic you do
        //if everything passed it should segue to the ConfirmationViewController.swift
        if selectedTime != 0 {
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            
            let year = components.year
            let month = components.month
            let day = components.day
            let hour = components.hour
            let minute = components.minute
            let second = components.second
            
            let today_string = String(year!)  + String(month!)  + String(day!)  + String(hour!)  + String(minute!)  +  String(second!)

            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("OrderCounter").observeSingleEvent(of: .value) { (orderSnapshot) in
                let orderNumber = String(orderSnapshot.value as! Int)
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("ActiveOrders").child(orderNumber).child("Address").setValue(addresses[selectedAddressIndex])
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("ActiveOrders").child(orderNumber).child("DeliveryTime").setValue(times[selectedTime])
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("ActiveOrders").child(orderNumber).child("TimeOrdered").setValue(today_string)

                
            }
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("OrderCounter").observeSingleEvent(of: .value) { (orderSnapshot) in
                var orderNumber = orderSnapshot.value as! Int
                
                orderNumber += 1
                let orderNumberString = String(orderNumber)
                
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("CurrentOrder").removeValue()
                
                //create the new order
                Database.database().reference().child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(orderNumberString).child("Time").setValue("TBD")
                
                //get the path to the new order
                let currentOrderPath = Database.database().reference().child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(orderNumberString).url

                //set the current order
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("CurrentOrder").child(orderNumberString).setValue(currentOrderPath)
                
                //set the new current order number
                Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("OrderCounter").setValue(orderNumber)
                
            }
            
            //TODO : wipe the cart and start over by incrementing the coutner for a new order and update user current Order
            let vc = ConfirmationViewController()
            self.present(vc, animated: true, completion: nil)

            
        }
        else {
            let alert = UIAlertController(title: "Incomplete Information",
                                          message: "Please Select a Delivery Time",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0
        
        if pickerView.tag == 10 {
            count = addresses.count
        }
        else if pickerView.tag == 20 {
            count = times.count
        }
        return count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String!
        
        if pickerView.tag == 10 {
            title = addresses[row]
        }
        else if pickerView.tag == 20 {
            title = times[row]
        }
        return title

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 10 {
            selectedAddressIndex = row
        }
        else if pickerView.tag == 20 {
            selectedTime = row
        }
        
    }

    private let reuseIdentifier = "Cell"
    let blackView = UIView()
    
    //address cell
    var addressPickerView : UIPickerView!
    var timePickerView : UIPickerView!

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
                    self.collectionView.reloadData()

                })
                
                
            }
            
        }
        
        
        
    }
    
    func getPhoneNumbers() {
        
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("phone number").observeSingleEvent(of: .value) { (phoneNumberSnapshot) in
            phoneNumber = phoneNumberSnapshot.value as! String
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                
            })
            
        }
    }
    let phoneNumberLabel : UILabel = {
        let label = UILabel()
        label.text = "Phone Number : "
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneNumberTextField : UITextField = {
        let label = UITextField()
        label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func presentSubMenu(index : Int) {
        //the address cell
        if index == 0 {
            subMenu = UIView()
            subMenu.backgroundColor = .white
            addressPickerView = UIPickerView()
            addressPickerView.tag = 10
            addressPickerView.translatesAutoresizingMaskIntoConstraints = false
            addressPickerView.delegate = self
            addressPickerView.dataSource = self
            
            //addressPickerView.tag = 0
            
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
            subMenu = UIView()
            subMenu.backgroundColor = .white
            
            
            
            phoneNumberTextField.placeholder = phoneNumber
            
            let switchPhoneNumberButton : UIButton = {
                let doneButton = UIButton(type: .system)
                doneButton.setTitle("Switch", for: .normal)
                doneButton.addTarget(self, action: #selector(handleSwitchPhoneNumber), for: .touchUpInside)
                doneButton.translatesAutoresizingMaskIntoConstraints = false
                return doneButton
            }()
            
            subMenu.addSubview(phoneNumberLabel)
            subMenu.addSubview(switchPhoneNumberButton)
            subMenu.addSubview(phoneNumberTextField)
            
            
            phoneNumberTextField.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            phoneNumberTextField.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            
            phoneNumberLabel.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            phoneNumberLabel.rightAnchor.constraint(equalTo: phoneNumberTextField.leftAnchor, constant: -5).isActive = true
            
            switchPhoneNumberButton.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            switchPhoneNumberButton.leftAnchor.constraint(equalTo: phoneNumberTextField.rightAnchor, constant: 10).isActive = true
            
            
        }
        //this is the phone number TODO : EVENTUALLY CHANGE THIS TO AN IN APP MESSAGING SYSTEM
        else if index == 2 {
            subMenu = UIView()
            subMenu.backgroundColor = .white
            
            timePickerView = UIPickerView()
            timePickerView.translatesAutoresizingMaskIntoConstraints = false
            timePickerView.tag = 20
            timePickerView.delegate = self
            timePickerView.dataSource = self
            
            let doneButton : UIButton = {
                let doneButton = UIButton(type: .system)
                doneButton.setTitle("Done", for: .normal)
                doneButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
                doneButton.translatesAutoresizingMaskIntoConstraints = false
                return doneButton
            }()
            
            subMenu.addSubview(timePickerView)
            subMenu.addSubview(doneButton)
            
            doneButton.leftAnchor.constraint(equalTo: subMenu.leftAnchor, constant: 20).isActive = true
            doneButton.topAnchor.constraint(equalTo: subMenu.topAnchor, constant: 5).isActive = true
            
            timePickerView.centerXAnchor.constraint(equalTo: subMenu.centerXAnchor).isActive = true
            timePickerView.centerYAnchor.constraint(equalTo: subMenu.centerYAnchor).isActive = true
            
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
    
    @objc func handleSwitchPhoneNumber() {
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("phone number").setValue(phoneNumberTextField.text)
        phoneNumberTextField.text = ""
        getPhoneNumbers()
        handleDismiss()
    }
    
    @objc func handleDismiss() {
        defaultAddressLabel.text = addresses[selectedAddressIndex]
        defaultTime.text = times[selectedTime]
        
        UIView.animate(withDuration: 0.25) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.subMenu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)

            }

        }
    }
    func setupViews() {
        view.addSubview(payButton)
        payButton.backgroundColor = .white
        
        payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 85).isActive = true
        payButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
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
        return 5
    }
    
    let defaultAddressLabel = UILabel()
    let defaultPhoneNumber = UILabel()
    let defaultTime = UILabel()
    
    
    let locationImage : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "LocationPin")
        return image
    }()
    
    let phoneImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "CheckoutPhone")
        return image
    }()
    
    let timeImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Time")
        return image
    }()
    
    let cardNumberTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Card Number"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 12
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let cardExpirationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "MM/YY"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 12
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let CVCTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "CVC"
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 12
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let savePaymentButton : UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Save", for: .normal)
        doneButton.addTarget(self, action: #selector(handleSavePayment), for: .touchUpInside)
        doneButton.backgroundColor = .green
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    
    
    var cardNumber : String!
    var expirationDate : String!
    var CVC : String!
    
    @objc func handleSavePayment() {
        if cardNumberTextField.text != "" && cardExpirationTextField.text != "" && CVCTextField.text != "" {
            cardNumber = cardNumberTextField.text
            expirationDate = cardExpirationTextField.text
            CVC = CVCTextField.text
        }
        else {
            return
        }
        
        //RIX TODO: SAVE STRIPE TOKEN TO FIREBASE
        
        
    }
    
    
    var subBalance : String!
    var deliveryCost : String!
    
    
    
    let subBalanceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let deliveryCostLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let totalCostLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let subBalanceTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sub Balance:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let deliveryCostTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Delivery Fee:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let totalCostTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Cost:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CheckoutCell
        if indexPath.item == 4 {
            
            
            
            deliveryCost = "5.99"
            let totalCost = Double(subBalance)! + Double(deliveryCost)!
            let realTotalCost = String(format: "%.2f", totalCost)
            
            
            subBalanceLabel.text = subBalance
            deliveryCostLabel.text = "$\(deliveryCost!)"
            totalCostLabel.text = ("$\(realTotalCost)")
            
            cell?.addSubview(subBalanceLabel)
            cell?.addSubview(deliveryCostLabel)
            cell?.addSubview(totalCostLabel)
            cell?.addSubview(subBalanceTitleLabel)
            cell?.addSubview(deliveryCostTitleLabel)
            cell?.addSubview(totalCostTitleLabel)
            
            subBalanceTitleLabel.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            subBalanceTitleLabel.topAnchor.constraint(equalTo: (cell?.topAnchor)!, constant: 5).isActive = true
            subBalanceLabel.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant : -5).isActive = true
            subBalanceLabel.topAnchor.constraint(equalTo: (cell?.topAnchor)!, constant: 5).isActive = true
            
            deliveryCostTitleLabel.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            deliveryCostTitleLabel.topAnchor.constraint(equalTo: subBalanceTitleLabel.bottomAnchor, constant: 5).isActive = true
            deliveryCostLabel.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant : -5).isActive = true
            deliveryCostLabel.topAnchor.constraint(equalTo: subBalanceLabel.bottomAnchor, constant: 5).isActive = true
            
            totalCostTitleLabel.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            totalCostTitleLabel.topAnchor.constraint(equalTo: deliveryCostTitleLabel.bottomAnchor, constant: 5).isActive = true
            totalCostLabel.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant : -5).isActive = true
            totalCostLabel.topAnchor.constraint(equalTo: deliveryCostLabel.bottomAnchor, constant: 5).isActive = true
        }
        else if(indexPath.item == 0) {
            if addresses.count > 0 {
                let dividerLineView : UIView = {
                    let view = UIView()
                    view.backgroundColor = .gray
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                let arrow : UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(named: "Arrow")
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    return imageView
                }()
                
                defaultAddressLabel.text = addresses[selectedAddressIndex]
                defaultAddressLabel.translatesAutoresizingMaskIntoConstraints = false
            
                
                locationImage.translatesAutoresizingMaskIntoConstraints = false
                
                
                cell?.addSubview(defaultAddressLabel)
                cell?.addSubview(locationImage)
                cell?.addSubview(dividerLineView)
                cell?.addSubview(arrow)

                dividerLineView.bottomAnchor.constraint(equalTo: (cell?.bottomAnchor)!).isActive = true
                dividerLineView.widthAnchor.constraint(equalTo: (cell?.widthAnchor)!).isActive = true
                dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

                arrow.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant: -10).isActive = true
                arrow.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                
                defaultAddressLabel.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
                defaultAddressLabel.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                
                locationImage.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                locationImage.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            }
            
        }
        else if indexPath.item == 1 {
            if phoneNumber != "" {
                let dividerLineView : UIView = {
                    let view = UIView()
                    view.backgroundColor = .gray
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                let arrow : UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(named: "Arrow")
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    return imageView
                }()
                
                defaultPhoneNumber.text = phoneNumber
                defaultPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
            
                
                phoneImage.translatesAutoresizingMaskIntoConstraints = false
            
                cell?.addSubview(phoneImage)
                cell?.addSubview(defaultPhoneNumber)
                cell?.addSubview(dividerLineView)
                cell?.addSubview(arrow)
                
                dividerLineView.bottomAnchor.constraint(equalTo: (cell?.bottomAnchor)!).isActive = true
                dividerLineView.widthAnchor.constraint(equalTo: (cell?.widthAnchor)!).isActive = true
                dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
                arrow.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant: -10).isActive = true
                arrow.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                
                defaultPhoneNumber.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
                defaultPhoneNumber.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true

                phoneImage.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
                phoneImage.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            }
        }
        else if indexPath.item == 2 {
            let dividerLineView : UIView = {
                let view = UIView()
                view.backgroundColor = .gray
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let arrow : UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "Arrow")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                return imageView
            }()
            
            defaultTime.text = "Select"
            defaultTime.translatesAutoresizingMaskIntoConstraints = false
            
            
            timeImage.translatesAutoresizingMaskIntoConstraints = false
            
            cell?.addSubview(timeImage)
            cell?.addSubview(defaultTime)
            cell?.addSubview(dividerLineView)
            cell?.addSubview(arrow)
            
            dividerLineView.bottomAnchor.constraint(equalTo: (cell?.bottomAnchor)!).isActive = true
            dividerLineView.widthAnchor.constraint(equalTo: (cell?.widthAnchor)!).isActive = true
            dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            arrow.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant: -10).isActive = true
            arrow.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
            
            defaultTime.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
            defaultTime.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
            
            timeImage.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
            timeImage.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 10).isActive = true
            
            
        }
        else if indexPath.item == 3 {
            let dividerLineView : UIView = {
                let view = UIView()
                view.backgroundColor = .gray
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let arrow : UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "Arrow")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                return imageView
            }()
            
            cell?.addSubview(cardNumberTextField)
            cell?.addSubview(cardExpirationTextField)
            cell?.addSubview(CVCTextField)
            cell?.addSubview(savePaymentButton)
            cell?.addSubview(dividerLineView)
            cell?.addSubview(arrow)
            
            dividerLineView.bottomAnchor.constraint(equalTo: (cell?.bottomAnchor)!).isActive = true
            dividerLineView.widthAnchor.constraint(equalTo: (cell?.widthAnchor)!).isActive = true
            dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            arrow.rightAnchor.constraint(equalTo: (cell?.rightAnchor)!, constant: -10).isActive = true
            arrow.centerYAnchor.constraint(equalTo: (cell?.centerYAnchor)!).isActive = true
            
            cardNumberTextField.topAnchor.constraint(equalTo: (cell?.topAnchor)!, constant: 5).isActive = true
            cardNumberTextField.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 5).isActive = true
            
            cardExpirationTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 5).isActive = true
            cardExpirationTextField.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 5).isActive = true
            
            CVCTextField.topAnchor.constraint(equalTo: cardExpirationTextField.bottomAnchor, constant: 5).isActive = true
            CVCTextField.leftAnchor.constraint(equalTo: (cell?.leftAnchor)!, constant: 5).isActive = true
            
            savePaymentButton.bottomAnchor.constraint(equalTo: (cell?.bottomAnchor)!, constant: -5).isActive = true
            savePaymentButton.widthAnchor.constraint(equalTo: (cell?.widthAnchor)!).isActive = true
            savePaymentButton.centerXAnchor.constraint(equalTo: (cell?.centerXAnchor)!).isActive = true
        }
       
        else {
            print("somethign went wrong in the checkout")
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 3  {
            return CGSize(width: view.frame.width, height: 150)
        }
        else if indexPath.item == 4 {
            return CGSize(width: view.frame.width, height: 80)
        }
        return CGSize(width: view.frame.width, height: 75)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < 3 {
            presentSubMenu(index : indexPath.item)

        }
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
        
    }
}
