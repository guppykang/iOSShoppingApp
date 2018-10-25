//
//  CollectionViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/23/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class ItemDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let headerId = "headerId"

    var item: Item?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = item?.name
        
        collectionView.alwaysBounceVertical = true
        print("hi mom ")
        collectionView.backgroundColor = .white
        
        collectionView.register(ItemDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ItemDetailHeader
        header.itemName.text = item?.name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
        
    }
    
   

}

class ItemDetailHeader: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        
        iv.image = UIImage(named: "JianYang")
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    let itemName: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    override init(frame: CGRect) {
        print("setting up cell")
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .blue
        addSubview(imageView)
        addSubview(itemName)
        
        addConstrainsWithFormat(format: "H:|-14-[v0]-14-|", views: imageView)
        //addConstrainsWithFormat(format: "V:|-14-[v0(150)]|", views: imageView)
        
        addConstrainsWithFormat(format: "H:|[v0]|", views: itemName)
        addConstrainsWithFormat(format: "V:|-14-[v0(150)][v1]-50-|", views: imageView, itemName)

        

    }
    
}

extension UIView {
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))

    }
}
