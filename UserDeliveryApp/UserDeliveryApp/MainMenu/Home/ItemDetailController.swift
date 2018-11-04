//
//  CollectionViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/23/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//


import UIKit
import Firebase

class ItemDetailController: UIViewController {
    
    var item: Item?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true

        //iv.image = UIImage(named: "JianYang")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv

    }()

    let itemName: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 16)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let price : UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addToCart : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.red, for: .normal)

        button.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false

        return button

    }()

    @objc func handleAddToCart() {
        getCurrentOrderNumber { (result) in
            
            print(result)
            let ref = Database.database().reference()
            
            ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(result).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if snapshot.hasChild((self.item?.serialNumber)!) {
                    let child = snapshot.childSnapshot(forPath: (self.item?.serialNumber)!)
                    let quantitySnapshot = child.childSnapshot(forPath: "Quantity")
                    
                    
                    var currentQuantity = (quantitySnapshot.value as? Int)!
                    currentQuantity += 1
                    
                    ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(result).child((self.item?.serialNumber)!).child("Quantity").setValue(currentQuantity)
                    
                    
                }
                else {
                    //create the item for the first time in the cart
                    ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(result).child((self.item?.serialNumber)!).child("Item").setValue(self.item?.path)
                    //create the count for that item
                    ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child(result).child((self.item?.serialNumber)!).child("Quantity").setValue(1)
                }
                
            })
            
            print("done")
        }
//        let ref = Database.database().reference()
//
//        ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child("Order1").observeSingleEvent(of: .value, with: { (snapshot) in
//
//
//            if snapshot.hasChild((self.item?.serialNumber)!) {
//                let child = snapshot.childSnapshot(forPath: (self.item?.serialNumber)!)
//                let quantitySnapshot = child.childSnapshot(forPath: "Quantity")
//
//
//                var currentQuantity = (quantitySnapshot.value as? Int)!
//                currentQuantity += 1
//
//                ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child("Order1").child((self.item?.serialNumber)!).child("Quantity").setValue(currentQuantity)
//
//
//            }
//            else {
//                //create the item for the first time in the cart
//                ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child("Order1").child((self.item?.serialNumber)!).child("Item").setValue(self.item?.path)
//                //create the count for that item
//                ref.child("ActiveOrders").child((Auth.auth().currentUser?.uid)!).child("Order1").child((self.item?.serialNumber)!).child("Quantity").setValue(1)
//            }
//
//        })
        
        
    }
    
    func getCurrentOrderNumberHelper(completion: @escaping (String) -> ()) {
        var orderNumber = ""
        
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("CurrentOrder").observeSingleEvent(of: .value, with: { (currentUserSnapshot) in
            let enumerator = currentUserSnapshot.children
            
            let item = enumerator.nextObject() as? DataSnapshot
            orderNumber = (item?.key)!
            print("Order Number : \(orderNumber)")
          
            completion(orderNumber)
        })
    }
    
    func getCurrentOrderNumber(completion: @escaping (String) -> ()) {
        DispatchQueue.main.async {
            self.getCurrentOrderNumberHelper(completion: { (result) in
                completion(result)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = item?.name
        view.backgroundColor = .white
        
        
        imageView.loadImageUsingCacheWithUrlString((item?.imageURL)!)
        itemName.text = item?.name!
        price.text = item?.price!
        
        setupViews()
    }
    
    func setupViews() {
    
        view.addSubview(imageView)
        view.addSubview(itemName)
        view.addSubview(price)
        view.addSubview(addToCart)
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        
        itemName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        
        price.topAnchor.constraint(equalTo: itemName.bottomAnchor).isActive = true
        price.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        addToCart.topAnchor.constraint(equalTo: price.bottomAnchor).isActive = true
        addToCart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}


//import UIKit
//
//class ItemDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//
//    private let headerId = "headerId"
//
//    var item: Item?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.title = item?.name
//
//        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .white
//
//        collectionView.register(ItemDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        // Register cell classes
//        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ItemDetailHeader
//        header.itemName.text = item?.name
//        //should probably do unwrap this safely
//        header.imageView.loadImageUsingCacheWithUrlString((item?.imageURL)!)
//        header.price.text = item?.price
//
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 600)
//
//    }
//
//
//
//}
//
//class ItemDetailHeader: UICollectionViewCell {
//    let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.layer.cornerRadius = 16
//        iv.layer.masksToBounds = true
//
//        //iv.image = UIImage(named: "JianYang")
//        iv.contentMode = .scaleAspectFill
//        return iv
//
//    }()
//
//    let itemName: UILabel = {
//        let label = UILabel()
//
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//
//    let price : UILabel = {
//        let label = UILabel()
//
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//
//    let addToCart : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Add", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.setTitleColor(.red, for: .normal)
//
//        button.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
//
//        return button
//
//    }()
//
//    @objc func handleAddToCart() {
//        print("add this item to the cart")
//    }
//
//    override init(frame: CGRect) {
//        print("setting up cell")
//        super.init(frame: frame)
//        setupViews()
//    }
//
//
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//        backgroundColor = .blue
//        addSubview(imageView)
//       // addSubview(itemName)
//       // addSubview(price)
//       addSubview(addToCart)
//
//
////        addConstrainsWithFormat(format: "H:|-15-[v0]|", views: itemName)
////        addConstrainsWithFormat(format: "H:|-15-[v0]|", views: price)
//
////        addConstrainsWithFormat(format: "V:|-90-[v0]|", views: itemName)
////        addConstrainsWithFormat(format: "V:|-125-[v0]|", views: price)
//
//        addConstrainsWithFormat(format: "H:|-14-[v0]-14-|", views: imageView)
//        addConstrainsWithFormat(format: "V:|-14-[v0]-300-|", views: imageView)
//
//
//        addConstrainsWithFormat(format: "H:|-15-[v0]|", views: addToCart)
//        addConstrainsWithFormat(format: "V:|-200-[v0]|", views: addToCart)
//
//    }
//
//}
//
//extension UIView {
//    func addConstrainsWithFormat(format: String, views: UIView...) {
//        var viewsDictionary = [String: UIView]()
//        for(index, view) in views.enumerated() {
//            let key = "v\(index)"
//            viewsDictionary[key] = view
//
//            view.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
//
//    }
//}
