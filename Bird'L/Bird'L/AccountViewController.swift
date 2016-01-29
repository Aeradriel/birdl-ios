//
//  AccountViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 23/06/2015.
//  Copyright (c) 2015 Birdl. All rights reserved.
//

import UIKit

class AccountViewController: FormViewController, UITextFieldDelegate
{
    //MARK: Variables
    let tags: [String : String] = [
        "birthdate": "date de naissance",
        "email": "email",
        "fname": "prénom",
        "lname": "nom",
        "password": "mot de passe",
        "country": "pays"
    ]
    var countriesRow: FormRowDescriptor!
    var countries: [Country] = []
    var countriesId: [Int] = []
    var countriesValue: [Int : String] = [Int : String]()
    
    var color1 = UIColor(red: 1, green: 135/255, blue: 117/255, alpha: 1)
    var color2 = UIColor(red: 1, green: 173/255, blue: 102/255, alpha: 1)
    var color3 = UIColor(red: 1, green: 117/255, blue: 147/255, alpha: 1)
    
    //MARK: UIViewController methods
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.navigationController!.view.backgroundColor = color1
        self.tableView.backgroundColor = UIColor.clearColor()
        Country.all(self.loadCountries, errorHandler: self.errorHandler)
        self.loadForm()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
        User.getBaseInfo(g_APICommunicator.token, errorHander: self.errorHandler, successHandler: self.updateUIWithUser)
    }
    
    //MARK: Loading countries
    func loadCountries(countries: [Country])
    {
        let row = self.countriesRow
        
        self.countries = countries
        for country in self.countries
        {
            
            self.countriesId.append(country.id)
            self.countriesValue[country.id] = country.name
            row.configuration[FormRowDescriptor.Configuration.Options] = self.countriesId
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor(red: 1, green: 1, blue: 1, alpha: 0.4), "titleLabel.textColor" : UIColor.blackColor()]
            row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] =
                { value in
                    switch (value)
                    {
                    default:
                        return self.countriesValue[value as! Int]
                    }
                } as TitleFormatterClosure
        }
    }
    
    //MARK: Keyboard handling
    func closeKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK: Checks
    func UserJsonIsValid(userJson: [String : JSON]) -> Bool
    {
        let requiredFields = ["email", "first_name", "last_name", "gender", "birthdate", "country"]
        
        for key in requiredFields
        {
            if userJson[key]!.isNull
            {
                return false
            }
        }
        return true
    }

    //MARK: Disconnect
    func disconnect()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("access-token")
        userDefaults.synchronize()
        self.tabBarController?.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Callbacks
    func updateUIWithUser(userJson: [String : JSON])
    {
        if self.UserJsonIsValid(userJson)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let date = dateFormatter.dateFromString(userJson["birthdate"]!.asString!)
            let country = userJson["country"]!.asDictionary
            
            self.setValue(userJson["email"]!.asString!, forTag: "email")
            self.setValue(userJson["first_name"]!.asString!, forTag: "fname")
            self.setValue(userJson["last_name"]!.asString!, forTag: "lname")
            self.setValue(userJson["gender"]!.asInt!, forTag: "gender")
            self.setValue(date!, forTag: "birthdate")
            self.setValue(country!["id"]!.asInt!, forTag: "country")
        }
    }
    
    func userDidUpdate()
    {
        let title = NSLocalizedString("profile_updated_title", comment: "")
        let message = NSLocalizedString("profile_updated_message", comment: "")
        
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func formSubmitted()
    {
        var error = ""
        
        for (key, value) in self.form.formValues()
        {
            if value as? NSNull != nil
            {
                let readableTag = self.tags[key as! String]
                
                error += "Le champ \"\(readableTag!)\" n'est pas rempli"
                error += "\n"
            }
        }
        if error != ""
        {
            UIAlertView(title: NSLocalizedString("error", comment: ""), message: error, delegate: nil, cancelButtonTitle: "OK").show()
        }
        else
        {
            User.update(userDictionary: self.form.formValues() as! [String : AnyObject], password: self.form.formValues()["password"] as! String, errorHandler: self.errorHandler, successHandler: self.userDidUpdate)
        }
    }
    
    func errorHandler(error: String)
    {
        UIAlertView(title: "Erreur", message: error, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    //MARK: Form
    func loadForm()
    {
        // Create form instace
        let form = FormDescriptor()
        form.title = "Mon compte"
        
        // Personnal informations
        let section1 = FormSectionDescriptor()
        var row: FormRowDescriptor
        
        section1.headerTitle = NSLocalizedString("personal_informations", comment: "")
        row = FormRowDescriptor(tag: "fname", rowType: .Email, title: "Prénom")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "John", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : color2, "textField.textColor" : color3, "titleLabel.textColor" : UIColor.blackColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "lname", rowType: .Email, title: "Nom")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Doe", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : color2, "textField.textColor" : color3, "titleLabel.textColor" : UIColor.blackColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "email", rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "john.doe@johndoe.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : color2, "textField.textColor" : color3, "titleLabel.textColor" : UIColor.blackColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "birthdate", rowType: .Date, title: "Date de naissance")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : UIColor.blackColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "gender", rowType: .SegmentedControl, title: "Sexe")
        row.configuration[FormRowDescriptor.Configuration.Options] = [1, 2]
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : UIColor.blackColor(), "segmentedControl.tintColor" : color3]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] =
            { value in
                switch (value)
                {
                    case 1:
                        return "Homme"
                    case 2:
                        return "Femme"
                default:
                    return nil
                }
        } as TitleFormatterClosure
        row.value = 1
        section1.addRow(row)
        row = FormRowDescriptor(tag: "country", rowType: .Picker, title: "Pays")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : UIColor.blackColor()]
        self.countriesRow = row
        section1.addRow(row)
        
        // Password
        let section2 = FormSectionDescriptor()
        
        section2.footerTitle = "Nous avons besoin de votre mot de passe pour enregistrer les changements sur votre profil"
        row = FormRowDescriptor(tag: "password", rowType: .Password, title: "Mot de passe")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : UIColor.blackColor(), "textField.textColor" : color3, "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        // Submit
        let section3 = FormSectionDescriptor()

        row = FormRowDescriptor(tag: "submit", rowType: .Button, title: "Valider")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : color3]
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.formSubmitted()
        } as DidSelectClosure
        section3.addRow(row)
        
        // Disconnect
        let section4 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: "disconnect", rowType: .Button, title: "Déconnexion")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : color2, "titleLabel.textColor" : UIColor.redColor()]
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.disconnect()
            } as DidSelectClosure
        section4.addRow(row)
        
        form.sections = [section1, section2, section3, section4]
        self.form = form
    }
}
