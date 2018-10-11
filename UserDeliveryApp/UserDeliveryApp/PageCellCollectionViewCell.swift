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
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  private func setupLayout() {
        let topImageContainerView = UIView()
        topImageContainerView.backgroundColor = .blue
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
    
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
        topImageContainerView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
    
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    
//        descritionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
//        descritionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 24).isActive = true
//        descritionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -24).isActive = true
//        descritionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
    }
    
}
