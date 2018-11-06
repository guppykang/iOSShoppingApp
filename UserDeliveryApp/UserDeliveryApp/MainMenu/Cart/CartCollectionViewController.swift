//
//  CartCollectionViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 11/4/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase

class CartCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    private let cellId = "cellId"
    var cart : [Item] = []
    var quantities : [String] = []
    
    
    let checkoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CHECKOUT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.green, for: .normal)
        
        button.addTarget(self, action: #selector(handleCheckout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    @objc func handleCheckout() {
        print("hi dad ")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let deleteItemButton : UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "TrashCan")
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let minusItemButton : UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Minus")
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handleMinus), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let plusItemButton : UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Plus")
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.green, for: .normal)
        
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var bottomControlsStackView : UIStackView!
    
    func setupChangeQuantityBottomControl(index : Int) {
        bottomControlsStackView = UIStackView(arrangedSubviews: [nameLabel, deleteItemButton, minusItemButton, plusItemButton, doneButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if Int(quantities[index])! > 1 {
            deleteItemButton.isHidden = true
        }
        else {
            minusItemButton.isHidden = true
        }
        
        nameLabel.text = "            Item: \(String(index + 1))"
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85).isActive = true
        bottomControlsStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomControlsStackView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        
    }
    @objc func handleDone() {
        bottomControlsStackView.isHidden = true
        checkoutButton.isHidden = false
    }
    
    @objc func handlePlus() {
        print("handle plus")
    }
    @objc func handleMinus() {
        print("handle minus")
    }
    
    @objc func handleDelete() {
        print("handle delete")
    }
    
    
    
    func getCartItems() {
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("CurrentOrder").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            //Get the URL of the items, get the item's information, create the Item, and add the item to the array
            
            let cartSnapshot = enumerator.nextObject() as? DataSnapshot
            
            let orderReference = Database.database().reference(fromURL: (cartSnapshot?.value as? String)!)
            
            orderReference.observeSingleEvent(of: .value, with: { orderSnapshot in
                let cartEnumerator = orderSnapshot.children
                while let item = cartEnumerator.nextObject() as? DataSnapshot {
                    
                    if item.key != "Time" {
                        let itemSnapshot = item.childSnapshot(forPath: "Item")
                        let itemPath = (itemSnapshot.value as? String)!
                        let itemReference = Database.database().reference(fromURL: itemPath)
                        
                        let quantitySnapshot = item.childSnapshot(forPath: "Quantity")
                        let quantityInteger = (quantitySnapshot.value as? Int)!
                        let quantityOfItem  = String(quantityInteger)
                        self.quantities.append(quantityOfItem)
                        
                        itemReference.observeSingleEvent(of: .value, with: { currentItem in
                            if let dictionary = currentItem.value as? [String: AnyObject] {
                                
                                let itemToAdd = Item(dictionary: dictionary)
                                itemToAdd.path = itemPath
                                itemToAdd.serialNumber = (currentItem.key as? String)!
                                
                                DispatchQueue.main.async(execute: {
                                    self.cart.append(itemToAdd)

                                    self.collectionView.reloadData()
                                    
                                })
                            }
                            
                            
                        })
                    }
                }
            })
            
        }
    }
    
    func setupViews(){
        view.addSubview(checkoutButton)
        
        checkoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85).isActive = true
        checkoutButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        getCartItems()
        
        setupViews()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cart.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell
        print(cart[indexPath.item].name)
        cell.nameLabel.text = cart[indexPath.item].name
        cell.imageView.loadImageUsingCacheWithUrlString(cart[indexPath.item].imageURL!)
        cell.quantityLabel.text = "Quantity : \(quantities[indexPath.item])"
        cell.priceLabel.text = cart[indexPath.item].price
        cell.indexLabel.text = String(indexPath.item+1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 225)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkoutButton.isHidden = true
        setupChangeQuantityBottomControl(index: indexPath.item)
    }

}

class ItemCell: UICollectionViewCell {
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let quantityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()	
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let indexLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
        
    }()
    
    let arrow : UIImageView = {
        let image = UIImage(named: "Arrow")
        let imageView = UIImageView(image: image)
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
        backgroundColor = .white
        

        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(dividerLineView)
        addSubview(quantityLabel)
        addSubview(priceLabel)
        addSubview(indexLabel)
        addSubview(arrow)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: indexLabel.rightAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 20).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant : -10).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true

        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 10).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
}
