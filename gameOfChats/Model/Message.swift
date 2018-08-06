//
//  Message.swift
//  gameOfChats
//
//  Created by Son Vu on 7/29/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var text: String?
    var toId: String?
    var fromId: String?
    var timeStamp: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timeStamp = dictionary["timestamp"] as? NSNumber ?? 0
    }
}
