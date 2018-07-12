//
//  ViewController.swift
//  gameOfChats
//
//  Created by GVN on 7/11/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(btnBackTouched))
     
        let ref = Database.database().reference(fromURL: "https://gameofchats-dcb8a.firebaseio.com/")
        ref.updateChildValues(["key" : "valuee"])
    }
    
    @objc private func btnBackTouched() {
        let loginVC = LoginController()
        self.present(loginVC, animated: true, completion: nil)
    }
}

