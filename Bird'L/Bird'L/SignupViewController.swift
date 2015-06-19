//
//  SignupViewController.swift
//  Bird'L
//
//  Created by pierre-olivier maugis on 15/04/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func nextButtonUp(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signupSegue1") {
            var svc = segue.destinationViewController as SignupViewController2;
            svc.username = self.usernameField.text;
            svc.password = self.passwordField.text;
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
}

class SignupViewController2: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var genderPicker: UISwitch!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var username : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(username)
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonUp(sender: AnyObject) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signupSegue2") {
            var svc = segue.destinationViewController as SignupViewController3;
            svc.username = self.username;
            svc.password = self.password;
            svc.firstName = self.firstNameField.text;
            svc.lastName = self.lastNameField.text;
            svc.gender = self.genderPicker.on
            
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyyy/M/d"
            svc.birthDate = timeFormatter.stringFromDate(self.birthDatePicker.date);
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
}

class SignupViewController3: UIViewController {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    var username : String!
    var password : String!
    var firstName : String!
    var lastName : String!
    var gender : Bool!
    var birthDate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.birthDate);
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validButtonUp(sender: AnyObject) {
        
        g_APICommunicator.createAccount(username, password: password, first_name : firstName, last_name : lastName, gender : gender, birthdate: birthDate, country_id : 1)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
}