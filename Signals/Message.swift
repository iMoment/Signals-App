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
    
    var fromSenderID: String?
    var text: String?
    var timestamp: NSNumber?
    var toRecipientID: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        return fromSenderID == FIRAuth.auth()?.currentUser?.uid ? toRecipientID : fromSenderID
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromSenderID = dictionary["fromSenderID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toRecipientID = dictionary["toRecipientID"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
    }
}