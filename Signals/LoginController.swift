//
//  LoginController.swift
//  Signals
//
//  Created by Stanley Pan on 8/14/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    // MARK: Properties
    let userInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        button.addTarget(self, action: #selector(handleRegister), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func handleRegister() {
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else {
            print("Form is not valid.  Authentication failed.")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Successfully authenticated user
            let ref = FIRDatabase.database().referenceFromURL("https://signals-a7699.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
                print("Saved user successfully into Firebase db")
            })
            
        })
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.secureTextEntry = true
        return textField
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InsertImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(userInputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        
        setupUserInputContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
    }
    
    func setupUserInputContainerView() {
        // MARK: UserInputContainer constraints
        userInputContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userInputContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        userInputContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        userInputContainerView.heightAnchor.constraintEqualToConstant(150).active = true
        
        userInputContainerView.addSubview(nameTextField)
        userInputContainerView.addSubview(nameSeparatorView)
        userInputContainerView.addSubview(emailTextField)
        userInputContainerView.addSubview(emailSeparatorView)
        userInputContainerView.addSubview(passwordTextField)
        
        // MARK: nameTextField constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(userInputContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        nameTextField.heightAnchor.constraintEqualToAnchor(userInputContainerView.heightAnchor, multiplier: 1/3).active = true
        
        // MARK: nameSeparatorView constraints
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // MARK: emailTextField constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        emailTextField.heightAnchor.constraintEqualToAnchor(userInputContainerView.heightAnchor, multiplier: 1/3).active = true
        
        // MARK: emailSeparatorView constraints
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // MARK: passwordTextField constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        passwordTextField.heightAnchor.constraintEqualToAnchor(userInputContainerView.heightAnchor, multiplier: 1/3).active = true
    }
    
    func setupLoginRegisterButton() {
        // MARK: LoginRegisterButton constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(userInputContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func setupProfileImageView() {
        // MARK: ProfileImageView constraints
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(userInputContainerView.topAnchor, constant: -12).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}




extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}