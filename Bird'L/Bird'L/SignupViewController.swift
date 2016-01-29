//
//  SignupViewController.swift
//  Bird'L
//
//  Created by pierre-olivier maugis on 15/04/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.usernameField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("email", comment: ""), attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.passwordField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("password", comment: ""), attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.passwordField2.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("parsword_confirmation", comment: ""), attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func nextButtonUp(sender: AnyObject)
    {
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "signupSegue1") {
            
            if ((self.passwordField.text != self.passwordField2.text)) {
                self.displayError(NSLocalizedString("enter_same_password", comment: ""));
                return false;
            }
            else if (self.passwordField.text!.characters.count < 8) {
                self.displayError(NSLocalizedString("password_at_least_eight", comment: ""));
                return false
            }
            else if (!isValidEmail(self.usernameField.text!)) {
                self.displayError(NSLocalizedString("email_not_valid", comment: ""));
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
    
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var username : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.firstNameField.attributedPlaceholder = NSAttributedString(string: "First name", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.lastNameField.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: [NSForegroundColorAttributeName : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)])
        self.birthDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.birthDatePicker.datePickerMode = .CountDownTimer
        self.birthDatePicker.datePickerMode = .Date
    }
    
    @IBAction func nextButtonUp(sender: AnyObject) {

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if (identifier == "signupSegue2") {
            
            if (self.firstNameField.text!.characters.count < 1 || self.lastNameField.text!.characters.count < 1) {
                self.displayError(NSLocalizedString("must_enter_first_last_name", comment: ""))
                return false;
            }
            else if (calculateAge(self.birthDatePicker.date) < 18) {
                self.displayError(NSLocalizedString("must_be_over_18", comment: ""))
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
            
            
            if (self.genderControl.selectedSegmentIndex == 0) {
                svc.gender = false;
            }
            else {
                svc.gender = true;
            }
        
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyyy/M/d"
            svc.birthDate = timeFormatter.stringFromDate(self.birthDatePicker.date);
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func displayError(result : String) -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
        
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
        Country.all(self.loadCountries, errorHandler: nil)
        self.selectedCountry = countries.first
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: Load Countries
    func loadCountries(countries: [Country])
    {
        self.countries = countries
        self.countryPicker.reloadAllComponents()
    }
    
    //MARK: UIPickerView methods
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = self.countries[row].name
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        return myTitle
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
        let alertController = UIAlertController(title: NSLocalizedString("success", comment: ""), message:
            NSLocalizedString("account_created", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("tabBarControllerLoggedIn") as UIViewController
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("to_signin", comment: ""), style: UIAlertActionStyle.Default, handler:
            { (action) in
                self.presentViewController(alertController, animated: true, completion: nil)                
        }));
        self.showViewController(vc, sender: self)
    }
    
    func signupError(result: String) -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message:
            result, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}