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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func nextButtonUp(sender: AnyObject) {
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "signupSegue1") {
            
            if ((self.passwordField.text != self.passwordField2.text)) {
                self.displayError("Please enter the same password in both fields");
                return false;
            }
            else if (self.passwordField.text!.characters.count < 8) {
                self.displayError("Your password must lenght more than 8 characters");
                return false
            }
            else if (!isValidEmail(self.usernameField.text!)) {
                self.displayError("Your email is not valid");
                return false
            }
            return true;
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signupSegue1") {
            let svc = segue.destinationViewController as! SignupViewController2;
            svc.username = self.usernameField.text;
            svc.password = self.passwordField.text;
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(testStr)
    }
    
    func displayError(result : String) -> Void {
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonUp(sender: AnyObject) {

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if (identifier == "signupSegue2") {
            
            if (self.firstNameField.text!.characters.count < 1 || self.lastNameField.text!.characters.count < 1) {
                self.displayError("You must enter your first and last names")
                return false;
            }
            else if (calculateAge(self.birthDatePicker.date) < 18) {
                self.displayError("You must be over 18 to create an account")
                return false;
            }
            return true;
        }
        return false;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signupSegue2") {
            let svc = segue.destinationViewController as! SignupViewController3;
            svc.username = self.username;
            svc.password = self.password;
            svc.firstName = self.firstNameField.text;
            svc.lastName = self.lastNameField.text;
            svc.gender = self.genderPicker.on
        
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyyy/M/d"
            svc.birthDate = timeFormatter.stringFromDate(self.birthDatePicker.date);
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func displayError(result : String) -> Void {
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func calculateAge (birthday: NSDate) -> NSInteger {
        
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let unitFlags : NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let dateComponentNow : NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
        let dateComponentBirth : NSDateComponents = calendar.components(unitFlags, fromDate: birthday)
        
        if ( (dateComponentNow.month < dateComponentBirth.month) ||
            ((dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day))
            )
        {
            return dateComponentNow.year - dateComponentBirth.year - 1
        }
        else {
            return dateComponentNow.year - dateComponentBirth.year
        }
    }
    
}

class SignupViewController3: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Variables
    @IBOutlet weak var countryPicker: UIPickerView!
    
    var username : String!
    var password : String!
    var firstName : String!
    var lastName : String!
    var gender : Bool!
    var birthDate : String!
    var countries: [Country] = []
    var selectedCountry: Country!
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        
        view.addGestureRecognizer(tap)
        self.countries = Country.all(errorHandler: nil)
        self.selectedCountry = countries.first
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: UIPickerView mmethods
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row].name
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = countries[row]
    }
    
    //MARK: IBActions
    @IBAction func validButtonUp(sender: AnyObject) {
        
        User.create(username, password: password, first_name : firstName, last_name : lastName, gender : gender, birthdate: birthDate, country_id : selectedCountry.id, success: signupSucceed, errorFunc: signupError)
    }
    
    //MARK: Callbacks
    func signupSucceed() -> Void {
        let alertController = UIAlertController(title: "Success !", message:
            "Your account has been created", preferredStyle: UIAlertControllerStyle.Alert)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("tabBarControllerLoggedIn") as UIViewController
        
        alertController.addAction(UIAlertAction(title: "To Signin", style: UIAlertActionStyle.Default, handler:
            { (action) in
                self.presentViewController(alertController, animated: true, completion: nil)                
        }));
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func signupError(result: String) -> Void {
        let alertController = UIAlertController(title: "Error", message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}