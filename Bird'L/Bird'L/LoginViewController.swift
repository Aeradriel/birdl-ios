//
//  LoginViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 15/03/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    //MARK: Variables
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var homeViewController: BirdlTabBarController!
    
    //MARK: UIViewController delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.secureTextEntry = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        self.loginField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.loginField.delegate = self
        self.passwordTextField.delegate = self
        self.checkToken()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarControllerLoggedIn") as! BirdlTabBarController
    }
    
    //MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Token check
    func loadHomeViewController()
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.showViewController(self.homeViewController, sender: self)
    }
    
    func checkToken()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        g_APICommunicator.checkToken(self.loadHomeViewController) { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    //MARK: Callbacks
    func DismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func signinSucceed() -> Void
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setValue(g_APICommunicator.token, forKey: "access-token")
        userDefaults.synchronize()
        self.showViewController(self.homeViewController, sender: self)
    }
    
    func signinError(result : String) -> Void
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signinButtonUp(sender: AnyObject)
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        g_APICommunicator.authenticateUser(loginField.text!, password: passwordTextField.text!, success: signinSucceed, errorFunc: signinError);
        
    }
    
    @IBAction func signupButtonUp(sender: AnyObject)
    {
    }
}

