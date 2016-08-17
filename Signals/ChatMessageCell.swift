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
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chatTextView)
        
        //  iOS9 Constraint Anchors
        chatTextView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        chatTextView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        chatTextView.widthAnchor.constraintEqualToConstant(200).active = true
        chatTextView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}