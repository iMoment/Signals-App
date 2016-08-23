//
//  ChatInputContainerView.swift
//  Signals
//
//  Created by Stanley Pan on 8/24/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSendMessage), forControlEvents: .TouchUpInside)
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadImage)))
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: "InsertChatMedia")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let sendButton = UIButton(type: .System)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
        uploadImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        uploadImageView.widthAnchor.constraintEqualToConstant(32).active = true
        uploadImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sendButton)
        
        sendButton.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraintEqualToAnchor(uploadImageView.rightAnchor, constant: 8).active = true
        self.inputTextField.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        self.inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        self.inputTextField.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
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