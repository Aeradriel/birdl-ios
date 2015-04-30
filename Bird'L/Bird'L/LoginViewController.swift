//
//  LoginViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 15/03/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinButtonUp(sender: AnyObject) {
        
    }
    @IBAction func signupButtonUp(sender: AnyObject) {
    }
}

