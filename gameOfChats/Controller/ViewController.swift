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
        
        if Auth.auth().currentUser?.uid == nil {
            handlerLogout()
        } else {
            print(Auth.auth().currentUser?.uid)
        }
    }
    
    @objc private func btnBackTouched() {
        let loginVC = LoginController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    private func handlerLogout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginVC = LoginController()
        self.present(loginVC, animated: true, completion: nil)
    }
}

