//
//  PageCellCollectionViewCell.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/9/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class PageCellCollectionViewCell: UICollectionViewCell {
    var page : Page? {
        didSet {
            
            /***** Image View *****/
            //use this to make sure that unwrapped actually has some data inside of it
            guard let unwrappedPage = page else {return}
            
            imageView.image = UIImage(named : unwrappedPage.imageName)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            /***** Description Text View *****/
            let attributeText = NSMutableAttributedString(string : unwrappedPage.headerText, attributes : [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
            attributeText.append(NSAttributedString(string: unwrappedPage.footerText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
            
            descritionTextView.attributedText = attributeText
            descritionTextView.textAlignment = .center
            descritionTextView.isEditable = false
            descritionTextView.isScrollEnabled = false
            descritionTextView.translatesAutoresizingMaskIntoConstraints = false

        }
    }
    
    private let imageView : UIImageView = {
        
        let image = UIImage(named: "JianYang")
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private let descritionTextView : UITextView = {
        let textView = UITextView()
        
        
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let topImageContainerView = UIView()
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
    
        addSubview(descritionTextView   )
        descritionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descritionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant : 24).isActive = true
        descritionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant : -24).isActive = true
        descritionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    
    }
    
}
