//
//  ChatLogController.swift
//  Signals
//
//  Created by Stanley Pan on 8/16/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

//
//  ChatLogController handles view of present conversation with User
import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, toId = user?.id else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                
                self.messages.append(message)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        // contentInset goes hand in hand with scrollIndicatorInsets
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .Interactive
        
//        setupKeyboardObservers()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.whiteColor()
        
        let uploadImageView = UIImageView()
        uploadImageView.userInteractionEnabled = true
        uploadImageView.image = UIImage(named: "InsertChatMedia")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        containerView.addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        uploadImageView.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        uploadImageView.widthAnchor.constraintEqualToConstant(32).active = true
        uploadImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSendMessage), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        containerView.addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraintEqualToAnchor(uploadImageView.rightAnchor, constant: 8).active = true
        self.inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        self.inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        self.inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        separatorLineView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
        
        return containerView
    }()
    
    func handleUploadImage() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            print(editedImage.size)
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImageToFirebaseStorage(selectedImage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func uploadImageToFirebaseStorage(image: UIImage) {
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let imageUploadData = UIImageJPEGRepresentation(image, 0.2) {
            storageRef.putData(imageUploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload the image:", error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl)
                }
                
            })
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        
        let values = ["imageUrl": imageUrl, "toRecipientID": toId, "fromSenderID": fromId, "timestamp": timestamp]
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error)
                return
            }
            
            //  Clear textfield after user has pushed send button
            self.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId : 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId : 1])
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //  Will stay on top of keyboard at all times
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        //  TODO: Move the input area up relative to the height of the keyboard
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animateWithDuration(keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        //  TODO: Move the input area up relative to the height of the keyboard
        containerViewBottomAnchor?.constant = 0
        UIView.animateWithDuration(keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.chatTextView.text = message.text
        
        setupCell(cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 26
        }
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromSenderID == FIRAuth.auth()?.currentUser?.uid {
            //  Message will be blue bubbleView
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.chatTextView.textColor = UIColor.whiteColor()
            cell.profileImageView.hidden = true
            cell.bubbleRightAnchor?.active = true
            cell.bubbleLeftAnchor?.active = false
        } else {
            //  Message will be grey bubbleView
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.chatTextView.textColor = UIColor.blackColor()
            cell.profileImageView.hidden = false
            cell.bubbleRightAnchor?.active = false
            cell.bubbleLeftAnchor?.active = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //  Get height of text (estimated)
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        let width = UIScreen.mainScreen().bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 275, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleSendMessage() {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toRecipientID": toId, "fromSenderID": fromId, "timestamp": timestamp]

        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error)
                return
            }
            
            //  Clear textfield after user has pushed send button
            self.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId : 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId : 1])
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSendMessage()
        return true
    }
}













