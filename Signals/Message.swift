//
//  Message.swift
//  Signals
//
//  Created by Stanley Pan on 8/16/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//
//  Class to hold Message object

import UIKit
import Firebase

class Message: NSObject {
    
    var senderID: String?
    var text: String?
    var timestamp: NSNumber?
    var recipientID: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        return senderID == FIRAuth.auth()?.currentUser?.uid ? recipientID : senderID
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        senderID = dictionary["senderID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        recipientID = dictionary["recipientID"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
    }
}