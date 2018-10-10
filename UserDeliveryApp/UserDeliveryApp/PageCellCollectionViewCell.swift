//
//  PageCellCollectionViewCell.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/9/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class PageCellCollectionViewCell: UICollectionViewCell {
    
    private let imageView : UIImageView = {
        
        let image = UIImage(named: "JianYang.png")
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        
        //setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//    private func setupLayout() {
//
//        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
////        descritionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 150).isActive = true
////        descritionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 24).isActive = true
////        descritionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -24).isActive = true
////        descritionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//    }
    
}
