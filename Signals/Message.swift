//
//  Message.swift
//  Signals
//
//  Created by Stanley Pan on 8/16/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

//
//  Class to hold Message object
import UIKit

class Message: NSObject {
    var fromSenderID: String?
    var text: String?
    var timestamp: NSNumber?
    var toRecipientID: String?
}
