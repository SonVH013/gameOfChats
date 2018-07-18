//
//  User.swift
//  gameOfChats
//
//  Created by GVN on 7/13/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import UIKit

class User: NSObject {
    var email: String?
    var name: String?
    var password: String?
    var imgUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.imgUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
