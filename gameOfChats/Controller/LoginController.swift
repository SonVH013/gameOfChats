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
    
    var messageController: MessageController?
    
    lazy var profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "profile")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerProfileSelect)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
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
        btn.addTarget(self, action: #selector(handlerLoginRegister), for: .touchUpInside)
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
    
    let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(handlerSegmentControl), for: .valueChanged)
        return segment
    }()
    
    var containerHeighContraint: NSLayoutConstraint?
    var nameTfHeighConstraint: NSLayoutConstraint?
    var emailTfHeighConstraint: NSLayoutConstraint?
    var passTfHeighConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        view.addSubview(inputContainerView)
        view.addSubview(registerBtn)
        view.addSubview(segmentedControl)
        view.addSubview(profileImageView)
        
        setupProfileImageView()
        setupInputsContainerView()
        setupInputsRegisterBtn()
        setupSegmentControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func handlerProfileSelect() {
        print("profile select")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        if let editedImg = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImg
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImage = selectedImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handlerLoginRegister() {
        if segmentedControl.selectedSegmentIndex == 0 {
            handlerLogin()
        } else {
            handlerRegister()
        }
    }
    
    private func handlerLogin() {
        print("login")
        guard let email = emailTf.text, let password = passTf.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print(err)
                return
            }
            self.messageController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func handlerRegister() {
        print("register")
        btnRegisterTouched()
    }
    
    @objc private func handlerSegmentControl() {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        registerBtn.setTitle(title, for: .normal)
        //setup contraint
        print(segmentedControl.selectedSegmentIndex)
        containerHeighContraint?.constant = segmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        //name constraints
        nameTfHeighConstraint?.isActive = false
        nameTfHeighConstraint = nameTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTfHeighConstraint?.isActive = true
        //email constraint
        emailTfHeighConstraint?.isActive = false
        emailTfHeighConstraint = emailTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTfHeighConstraint?.isActive = true
        //pass constraint
        passTfHeighConstraint?.isActive = false
        passTfHeighConstraint = passTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passTfHeighConstraint?.isActive = true
    }
    
    private func setupSegmentControl() {
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -10).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
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
        containerHeighContraint = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        containerHeighContraint?.isActive = true
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
        nameTfHeighConstraint = nameTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTfHeighConstraint?.isActive = true
    }
    
    private func setupInputEmailTf() {
        emailTf.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTf.topAnchor.constraint(equalTo: nameTf.bottomAnchor, constant: 0).isActive = true
        emailTf.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTfHeighConstraint = emailTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTfHeighConstraint?.isActive = true
    }
    
    private func setupInputPasswordTf() {
        passTf.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passTf.topAnchor.constraint(equalTo: emailTf.bottomAnchor, constant: 0).isActive = true
        passTf.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passTfHeighConstraint = passTf.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passTfHeighConstraint?.isActive = true
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
    
    private func btnRegisterTouched() {
        guard let email = emailTf.text, let password = passTf.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let error = err {
                print(error)
                return
            }
            guard let uid =  user?.user.uid else {
                return
            }
            //let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
                let storage = Storage.storage().reference().child("myImages").child("\(UUID.init()).png")
                storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    guard let metadata = metadata else {
                        return
                    }
                    storage.downloadURL(completion: { (url, error) in
                        if let err = err{
                            print("Unable to retrieve URL due to error: \(err.localizedDescription)")
                        }
                        if let url = url?.absoluteString {
                            let values = ["name": self.nameTf.text!, "email": self.emailTf.text!, "password": self.passTf.text!, "profileImageUrl": url]
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        }
        
    }
    
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            
            self.messageController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
}
