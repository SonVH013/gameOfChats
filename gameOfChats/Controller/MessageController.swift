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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handlerLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New message", style: .plain, target: self, action: #selector(handlerNewMessage))
        checkIfUserIsLoggedIn()
    }
    
    @objc private func handlerLogout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginVC = LoginController()
        loginVC.messageController = self
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
            fetchUserAndSetupNavBarTitle()
            
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        print("uid \(uid)")
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.navigationItem.title = dictionary["name"] as? String
            }
        }, withCancel: nil)
    }
}

