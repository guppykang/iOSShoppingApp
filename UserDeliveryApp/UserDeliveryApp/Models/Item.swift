//
//  Item.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/18/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class Item: NSObject {
    var descrip : String?
    var imageURL : String?
    var name : String?
    var price : String?
    var path : String?
    
    
    init(dictionary: [String: Any]) {
        self.descrip = dictionary["Description"] as? String
        self.imageURL = dictionary["ImageUrl"] as? String
        self.name = dictionary["Name"] as? String
        self.price = dictionary["Price"] as? String
    }
    
}
