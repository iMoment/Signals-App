//
//  ChatInputContainerView.swift
//  Signals
//
//  Created by Stanley Pan on 8/24/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//
//  Custom ChatInputContainerView for ChatLogController

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    weak var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSendMessage), forControlEvents: .TouchUpInside)
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadImage)))
        }
    }
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: "InsertChatMedia")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Send", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        //  iOS 9 Constraint Anchors
        addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
        uploadImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        uploadImageView.widthAnchor.constraintEqualToConstant(32).active = true
        uploadImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        addSubview(sendButton)
        sendButton.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        addSubview(inputTextField)
        inputTextField.leftAnchor.constraintEqualToAnchor(uploadImageView.rightAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        separatorLineView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        chatLogController?.handleSendMessage()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}