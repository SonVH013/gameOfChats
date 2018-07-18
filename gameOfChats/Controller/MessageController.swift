//
//  ViewController.swift
//  gameOfChats
//
//  Created by GVN on 7/11/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(btnBackTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New message", style: .plain, target: self, action: #selector(handlerNewMessage))
        checkIfUserIsLoggedIn()
    }
    
    @objc private func btnBackTouched() {
        let loginVC = LoginController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func handlerLogout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginVC = LoginController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @objc func handlerNewMessage() {
        let newMessController = NewMessageViewController()
        let naviController = UINavigationController(rootViewController: newMessController)
        present(naviController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handlerLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (dataSnapshot) in
                print(dataSnapshot)
                if let dict = dataSnapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dict["name"] as? String
                }
            }
            
        }
    }
}

