//
//  LoginController.swift
//  gameOfChats
//
//  Created by GVN on 7/11/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginController: UIViewController {
    
    let inputContainerView: UIView = {
        let inputContainerView = UIView()
        inputContainerView.backgroundColor = UIColor.white
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.layer.cornerRadius = 10
        inputContainerView.layer.masksToBounds = true
        return inputContainerView
    }()
    
    let registerBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = UIColor.cyan
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnRegisterTouched), for: .touchUpInside)
        
        return btn
    }()
    
    let nameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        view.addSubview(inputContainerView)
        view.addSubview(registerBtn)
        
        setupInputsContainerView()
        setupInputsRegisterBtn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension LoginController {
    private func setupInputsContainerView() {
        inputContainerView.addSubview(nameTf)
        inputContainerView.addSubview(nameSeperator)
        inputContainerView.addSubview(emailTf)
        inputContainerView.addSubview(emailSeperator)
        inputContainerView.addSubview(passTf)
        
        setupInputNameTf()
        setupInputEmailTf()
        setupInputPasswordTf()
        setupNameSeperator()
        setupEmailSeperator()
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -32).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setupInputsRegisterBtn() {
        registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 10).isActive = true
        registerBtn.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        registerBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupInputNameTf() {
        nameTf.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTf.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0).isActive = true
        nameTf.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    private func setupInputEmailTf() {
        emailTf.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTf.topAnchor.constraint(equalTo: nameTf.bottomAnchor, constant: 0).isActive = true
        emailTf.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    private func setupInputPasswordTf() {
        passTf.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passTf.topAnchor.constraint(equalTo: emailTf.bottomAnchor, constant: 0).isActive = true
        passTf.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    private func setupNameSeperator() {
        nameSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 0).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTf.bottomAnchor, constant: 0).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupEmailSeperator() {
        emailSeperator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 0).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTf.bottomAnchor, constant: 0).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc private func btnRegisterTouched() {
        print("registered")
        Auth.auth().createUser(withEmail: emailTf.text!, password: passTf.text!) { (user, err) in
            if let error = err {
                print(error)
            }
            //save to db
            var uid = ""
            let ref = Database.database().reference(fromURL: "https://gameofchats-dcb8a.firebaseio.com/")
            if let user = Auth.auth().currentUser {
                uid = user.uid
            }
            let childRef = ref.child("users").child(uid)
            let value = ["name": self.nameTf.text!, "email": self.emailTf.text!, "password": self.passTf.text!]
            childRef.updateChildValues(value)
        }
        
    }
}
