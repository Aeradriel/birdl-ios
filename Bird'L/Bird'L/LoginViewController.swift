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
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func signinSucceed() -> Void {
        println("signin succeed")
        //
        //
        //
        //
        //
        // present home view here
        //
        //
        //
        //
    }
    
    func signinError(result : String) -> Void {
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signinButtonUp(sender: AnyObject) {
        g_APICommunicator.authenticateUser(loginField.text, password: passwordTextField.text, success: signinSucceed, errorFunc: signinError);
        
    }
    
    
    @IBAction func signupButtonUp(sender: AnyObject) {
    }
}

