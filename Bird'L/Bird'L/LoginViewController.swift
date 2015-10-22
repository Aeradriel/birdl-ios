//
//  LoginViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 15/03/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    //MARK: Variables
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: UIViewController delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Callbacks
    func DismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func signinSucceed() -> Void
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setValue(g_APICommunicator.token, forKey: "access-token")
        userDefaults.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signinError(result : String) -> Void
    {
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signinButtonUp(sender: AnyObject)
    {
        g_APICommunicator.authenticateUser(loginField.text!, password: passwordTextField.text!, success: signinSucceed, errorFunc: signinError);
        
    }
    
    @IBAction func signupButtonUp(sender: AnyObject)
    {
    }
}

