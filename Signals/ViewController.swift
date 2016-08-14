//
//  ViewController.swift
//  Signals
//
//  Created by Stanley Pan on 8/14/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout() {
        let loginController = LoginController()
        presentViewController(loginController, animated: true, completion: nil)
    }
}

