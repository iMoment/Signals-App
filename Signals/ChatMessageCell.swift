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
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(chatTextView)
        
        //  iOS9 Constraint Anchors
        bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        
        bubbleView.widthAnchor.constraintEqualToConstant(200).active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
//        chatTextView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        chatTextView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        chatTextView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
//        chatTextView.widthAnchor.constraintEqualToConstant(200).active = true
        chatTextView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        chatTextView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}