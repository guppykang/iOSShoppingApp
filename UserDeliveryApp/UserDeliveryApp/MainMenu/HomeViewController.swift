//
//  HomeViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/14/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //Create a dictionary that encodes a string to an array of items
    var categories : [String] = []
    var itemsSeparatedByCategory : [String : [Item]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
        // Do any additional setup after loading the view.
        getUserInfo()
    }
    
    func getUserInfo() {
        Database.database().reference().child("HomeFeatured").observe(.childAdded, with: { (snapshot) in
            
            print("Category name: \(snapshot.key)")
            self.categories.append(snapshot.key)
            print("number of children: \(snapshot.childrenCount)")
            
            var items : [Item] = []
            
            
            let enumerator = snapshot.children
            //Get the URL of the items, get the item's information, create the Item, and add the item to the array
            while let item = enumerator.nextObject() as? DataSnapshot {
                let reference = Database.database().reference(fromURL: (item.value as? String)!)
                reference.observeSingleEvent(of: .value, with: { snapshot in
                    print(snapshot)
                    //Create the init for Item, and feed this data in
                    //figure out how to sync this data after it is finished
                })

            }
            
            //add the new Category's items to the dictionary
            self.itemsSeparatedByCategory.updateValue(items, forKey: snapshot.key)
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
            
        }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCell
        //set the Category Label with the key of the dictionary, and set the array to the value of the dictionary
        cell.categoryLabel.text = categories[indexPath.item]
        
        //set the cell's items to the array of items of which it corresponds to its category
        cell.items = itemsSeparatedByCategory[categories[indexPath.item]]!
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //creates the cells to be the length and height of the entire view
        return CGSize(width: view.frame.width, height: 225)
    }

}

