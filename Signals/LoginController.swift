//
//  LoginController.swift
//  Signals
//
//  Created by Stanley Pan on 8/14/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let userInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(userInputContainerView)
        view.addSubview(loginRegisterButton)
        
        setupUserInputContainerView()
        setupLoginRegisterButton()
    }
    
    func setupUserInputContainerView() {
        // MARK: UserInputContainer constraints
        userInputContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userInputContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        userInputContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        userInputContainerView.heightAnchor.constraintEqualToConstant(150).active = true
        
        userInputContainerView.addSubview(nameTextField)
        // MARK: nameTextField constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(userInputContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(userInputContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        nameTextField.heightAnchor.constraintEqualToAnchor(userInputContainerView.heightAnchor, multiplier: 1/3).active = true
        
    }
    
    func setupLoginRegisterButton() {
        // MARK: LoginRegisterButton constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(userInputContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(userInputContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
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