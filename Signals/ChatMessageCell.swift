//
//  ChatMessageCell.swift
//  Signals
//
//  Created by Stanley Pan on 8/18/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//
//  Custom ChatMessageCell Class

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    var chatLogController: ChatLogController?
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "PlayButton")
        button.tintColor = UIColor.whiteColor()
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: #selector(handlePlay), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    func handlePlay() {
        if let videoUrlString = message?.videoUrl, url = NSURL(string: videoUrlString) {
            player = AVPlayer(URL: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            
            bubbleView.layer.addSublayer(playerLayer!)
            
            player?.play()
            loadingIndicatorView.startAnimating()
            playButton.hidden = true
            
            print("Attempting to play video...")
        }
    }
    
    //  Reset the cell
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        loadingIndicatorView.stopAnimating()
    }
    
    let chatTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Text"
        textView.font = UIFont.systemFontOfSize(16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        textView.editable = false
        
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
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOnTap)))
        
        return imageView
    }()
    
    func handleZoomOnTap(tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomForImageOnTap(imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(chatTextView)
        addSubview(profileImageView)
        
        //  iOS9 Constraint Anchors
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor).active = true
        messageImageView.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor).active = true
        messageImageView.widthAnchor.constraintEqualToAnchor(bubbleView.widthAnchor).active = true
        messageImageView.heightAnchor.constraintEqualToAnchor(bubbleView.heightAnchor).active = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraintEqualToAnchor(bubbleView.centerXAnchor).active = true
        playButton.centerYAnchor.constraintEqualToAnchor(bubbleView.centerYAnchor).active = true
        playButton.widthAnchor.constraintEqualToConstant(75).active = true
        playButton.heightAnchor.constraintEqualToConstant(75).active = true
        
        bubbleView.addSubview(loadingIndicatorView)
        loadingIndicatorView.centerXAnchor.constraintEqualToAnchor(bubbleView.centerXAnchor).active = true
        loadingIndicatorView.centerYAnchor.constraintEqualToAnchor(bubbleView.centerYAnchor).active = true
        loadingIndicatorView.widthAnchor.constraintEqualToConstant(75).active = true
        loadingIndicatorView.heightAnchor.constraintEqualToConstant(75).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8)
        bubbleRightAnchor?.active = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(275)
        bubbleWidthAnchor?.active = true
        
        chatTextView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        chatTextView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        chatTextView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        chatTextView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}