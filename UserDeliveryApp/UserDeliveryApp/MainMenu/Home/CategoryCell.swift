//
//  CategoryViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/14/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CategoryCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let cellId = "appCellId"

    //all the items in this specific category
    var items : [Item] = []
    
    var homeViewController: HomeViewController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //setupItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //when we set the category name, it gets all the items from that category and puts them in an array
    var categoryName : String? {
        didSet {
            Database.database().reference().child("HomeFeatured").child(categoryName!).observeSingleEvent(of: .value) { (snapshot) in
                let enumerator = snapshot.children
                //Get the URL of the items, get the item's information, create the Item, and add the item to the array
                while let item = enumerator.nextObject() as? DataSnapshot {
                    let reference = Database.database().reference(fromURL: (item.value as? String)!)
                    
                    reference.observeSingleEvent(of: .value, with: { currentItem in
                        if let dictionary = currentItem.value as? [String: AnyObject] {
                            
                            let itemToAdd = Item(dictionary: dictionary)
                            itemToAdd.path = (item.value as? String)!
                            itemToAdd.serialNumber = (currentItem.key as? String)!
                            self.items.append(itemToAdd)
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.appsCollectionView.reloadData()
                            
                        })
                    })
                    
                }
                
            }
        }
    }

    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Most Popular"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(categoryLabel)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v3(30)][v0][v1(0.5)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "v3": categoryLabel]))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        //cell.imageView.image = UIImage(named: "JianYang")
        //cell.nameLabel.text = "Jian Yang"
        cell.imageView.loadImageUsingCacheWithUrlString(items[indexPath.item].imageURL!)
        cell.nameLabel.text = items[indexPath.item].name
        cell.categoryLabel.text = categoryName
        cell.priceLabel.text = "$\(self.items[indexPath.item].price!)"
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //creates the cells to be the length and height of the entire view
        return CGSize(width: 100, height: frame.height-32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item selected : \(String(describing: items[indexPath.item].name))")
        homeViewController?.showAppDetailForApp(items[indexPath.item])
    }
}


class AppCell : UICollectionViewCell {
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
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)  //TODO : CHANGE THIS DEPENDING WHETHER OR NOT THE TITLE IS MORE THAN TWO LINES OR NOT
        priceLabel.frame = CGRect(x: 0, y: frame.width + 58, width: frame.width, height: 20)
    }

}
