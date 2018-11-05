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
                        print(itemReference)
                        
                        
                        itemReference.observeSingleEvent(of: .value, with: { currentItem in
                            if let dictionary = currentItem.value as? [String: AnyObject] {
                                
                                let itemToAdd = Item(dictionary: dictionary)
                                itemToAdd.path = itemPath
                                itemToAdd.serialNumber = (currentItem.key as? String)!
                                self.cart.append(itemToAdd)
                            }
                            
                            DispatchQueue.main.async(execute: {
                                self.collectionView.reloadData()
                                
                            })
                        })
                    }
                }
            })
            
            print("Done")
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        getCartItems()
        
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cart.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell
        cell.nameLabel.text = cart[indexPath.item].name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 225)
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
    
    let categoryLabel : UILabel = {
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setupViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .purple

       // addSubview(imageView)
        addSubview(nameLabel)
        //addSubview(categoryLabel)
        //addSubview(priceLabel)
        
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
    }
}
