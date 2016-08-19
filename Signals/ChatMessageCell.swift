//
//  ChatMessageCell.swift
//  Signals
//
//  Created by Stanley Pan on 8/18/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

//
//  Custom ChatMessageCell class
import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let chatTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Text"
        textView.font = UIFont.systemFontOfSize(16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        
        return textView
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        return imageView
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(chatTextView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        
        //  iOS9 Constraint Anchors
        bubbleRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8)
        bubbleRightAnchor?.active = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8)
//        bubbleLeftAnchor?.active = false
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(275)
        bubbleWidthAnchor?.active = true
        
        chatTextView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        chatTextView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        chatTextView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        chatTextView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        messageImageView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor).active = true
        messageImageView.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor).active = true
        messageImageView.widthAnchor.constraintEqualToAnchor(bubbleView.widthAnchor).active = true
        messageImageView.heightAnchor.constraintEqualToAnchor(bubbleView.heightAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}