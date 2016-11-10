//
//  LoginController+handlers.swift
//  Signals
//
//  Created by Stanley Pan on 8/15/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//
//  LoginController extension holding handle functions and other extensions

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    //  Toggles userInputContainerView according to loginRegisterSegmentedControl value
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        userInputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorViewHeightAnchor?.isActive = false
        nameSeparatorViewHeightAnchor = nameSeparatorView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1)
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameSeparatorViewHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: userInputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func handleLoginRegister() {
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? handleLogin() : handleRegister()
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.fadeLabelInAndOut(label: self.errorLabel, delay: 2, message: "The email or password entered is incorrect.")
                self.dismissKeyboard()
                return
            }
            
            //  Successfully logged in user
            self.messagesController?.fetchUserAndSetNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.fadeLabelInAndOut(label: self.errorLabel, delay: 2, message: "Please fill in all fields.")
                self.dismissKeyboard()
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Successfully created user
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metaData, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    func handleAnimateStars() {
        DispatchQueue.main.async {
            for _ in 0...40 {
                let whiteSquareStar = UIView()
                whiteSquareStar.frame = CGRect(x: 0, y: 0, width: 1.5, height: 1.5)
                whiteSquareStar.backgroundColor = .white
                self.view.addSubview(whiteSquareStar)
                
                let randomYOffset = CGFloat(arc4random_uniform(125))
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0,y: 55 + randomYOffset))
                path.addCurve(to: CGPoint(x: self.view.frame.size.width, y: 75 + randomYOffset), controlPoint1: CGPoint(x: 138, y: 270 + randomYOffset), controlPoint2: CGPoint(x: 276, y: -100 + randomYOffset))
                
                let animation = CAKeyframeAnimation(keyPath: "position")
                animation.path = path.cgPath
                animation.rotationMode = kCAAnimationRotateAuto
                animation.repeatCount = Float.infinity
                animation.duration = 5.0
                animation.duration = Double(arc4random_uniform(40) + 30) / 10
                animation.timeOffset = Double(arc4random_uniform(290))
                
                whiteSquareStar.layer.add(animation, forKey: "animate position along path")
            }
        }
    }
    
    func fadeLabelInAndOut(label: UILabel, delay: TimeInterval, message: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                label.alpha = 1
                label.text = message
            }) { (Bool) in
                UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseInOut, animations: {
                    label.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String:AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            let user = User()
            user.setValuesForKeys(values)
            
            self.messagesController?.setupNavBarWithUser(user)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    
    func alphaChange(value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

// MARK: UIColor Extension
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
