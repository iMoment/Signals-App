//
//  LoginController.swift
//  Signals
//
//  Created by Stanley Pan on 8/14/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//
//  LoginController - Handles logging in or registering a user

import UIKit
import Firebase
import Shimmer

class LoginController: UIViewController {
    
    // MARK: Properties
    var messagesController: MessagesController?
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let shimmeringView: FBShimmeringView = {
        let view = FBShimmeringView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Signals"
        label.font = UIFont(name: "Zapfino", size: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "InsertImage").alphaChange(value: 0.75)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    let userInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.25)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.textColor = .white
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.25)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.textColor = .white
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.25)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .white
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 0.35)
        button.setTitle("Register", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        applyMotionEffect(toView: backgroundImageView, magnitude: 10)
        applyMotionEffect(toView: shimmeringView, magnitude: -30)
        applyMotionEffect(toView: appNameLabel, magnitude: -30)
        applyMotionEffect(toView: profileImageView, magnitude: -30)
        applyMotionEffect(toView: loginRegisterSegmentedControl, magnitude: -30)
        applyMotionEffect(toView: userInputContainerView, magnitude: -30)
        applyMotionEffect(toView: loginRegisterButton, magnitude: -30)
        applyMotionEffect(toView: errorLabel, magnitude: -30)
        
        view.addSubview(backgroundImageView)
        view.addSubview(shimmeringView)
        view.addSubview(appNameLabel)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(userInputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(errorLabel)
        
        setupBackgroundImageView()
        setupShimmeringView()
        setupAppNameLabel()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupUserInputContainerView()
        setupLoginRegisterButton()
        setupErrorLabel()
        
        self.shimmeringView.contentView = appNameLabel
        self.shimmeringView.isShimmering = true
    }
    
    // MARK: UI Height Constraint Reference Variables
    var userInputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameSeparatorViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    // MARK: UI Constraint Setup Functions
    func setupBackgroundImageView() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -50).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 50).isActive = true
    }
    
    func setupShimmeringView() {
        shimmeringView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shimmeringView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        shimmeringView.widthAnchor.constraint(equalToConstant: 168).isActive = true
        shimmeringView.heightAnchor.constraint(equalToConstant: 136).isActive = true
    }

    func setupAppNameLabel() {
        appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        appNameLabel.widthAnchor.constraint(equalToConstant: 168).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 136).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupUserInputContainerView() {
        userInputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userInputContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 12).isActive = true
        userInputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        userInputContainerViewHeightAnchor = userInputContainerView.heightAnchor.constraint(equalToConstant: 150)
        userInputContainerViewHeightAnchor?.isActive = true
        
        userInputContainerView.addSubview(nameTextField)
        userInputContainerView.addSubview(nameSeparatorView)
        userInputContainerView.addSubview(emailTextField)
        userInputContainerView.addSubview(emailSeparatorView)
        userInputContainerView.addSubview(passwordTextField)

        nameTextField.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: userInputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor, constant: -24).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 12).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor, constant: -24).isActive = true
        nameSeparatorViewHeightAnchor = nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        nameSeparatorViewHeightAnchor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor, constant: -24).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 12).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor, constant: -24).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: userInputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: userInputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupErrorLabel() {
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 16).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func applyMotionEffect(toView view: UIView, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
