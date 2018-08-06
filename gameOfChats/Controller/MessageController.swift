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
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handlerLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New message", style: .plain, target: self, action: #selector(handlerNewMessage))
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        observerMessage()
    }
    
    var messages = [Message]()
    var messageDict = [String: Message]()
    
    func observerMessage() {
        let ref = Database.database().reference(withPath: "messages")
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                //self.messages.append(message)
                if let toId = message.toId {
                    self.messageDict[toId] = message
                    self.messages = Array(self.messageDict.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timeStamp!.intValue < message2.timeStamp!.intValue
                    })
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("text: \(message.text)")
            }
        }, withCancel: nil)
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
        newMessController.messageController = self
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
                self.setupNavbarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavbarWithUser(user: User) {
        self.navigationItem.title = user.name
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        //titleView.backgroundColor = UIColor.blue
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 28
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let profileImageUrl = user.imgUrl {
            profileImageView.loadImageUsingCache(urlString: profileImageUrl)
        }
        titleView.addSubview(profileImageView)
        //constraint
        profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.navigationItem.titleView = titleView
        //titleView.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        
    }
    
    @objc func showChatController(user: User) {
        print("123")
        let vc = ChatLogController(collectionViewLayout: UICollectionViewLayout())
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                        cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
        cell.detailTextLabel?.text = message.text
        if let seconds = message.timeStamp?.doubleValue {
            let date = Date(timeIntervalSince1970: seconds)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm:ss"
            cell.timeLabel.text = dateFormat.string(from: date)
        }
        return cell
    }
}

