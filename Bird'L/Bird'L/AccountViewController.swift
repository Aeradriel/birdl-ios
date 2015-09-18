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
    var countries: [Country] = []
    var countriesId: [Int] = []
    var countriesValue: [Int : String] = [Int : String]()
    
    //MARK: UIViewController methods
    //TODO: Find a way to put call in viewDidAppear
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.countries = Country.all(errorHandler: self.errorHandler)
        for country in self.countries
        {
            self.countriesId.append(country.id)
            self.countriesValue[country.id] = country.name
        }
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.view.backgroundColor = UIColor(patternImage: UIImage(named: "color18")!)
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        User.getBaseInfo(g_APICommunicator.token, errorHander: self.errorHandler, successHandler: self.updateUIWithUser)
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
        let title = "Profil mis à jour"
        let message = "Votre profil a bien été mis à jour"
        
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
            UIAlertView(title: "Erreur", message: error, delegate: nil, cancelButtonTitle: "OK").show()
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
        
        section1.headerTitle = "Informations personnelles"
        row = FormRowDescriptor(tag: "fname", rowType: .Email, title: "Prénom")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "John", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "textField.textColor" : UIColor.orangeColor(), "titleLabel.textColor" : UIColor.whiteColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "lname", rowType: .Email, title: "Nom")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Doe", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "textField.textColor" : UIColor.orangeColor(), "titleLabel.textColor" : UIColor.whiteColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "email", rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "john.doe@johndoe.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "textField.textColor" : UIColor.orangeColor(), "titleLabel.textColor" : UIColor.whiteColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "birthdate", rowType: .Date, title: "Date de naissance")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "titleLabel.textColor" : UIColor.whiteColor()]
        section1.addRow(row)
        row = FormRowDescriptor(tag: "gender", rowType: .SegmentedControl, title: "Sexe")
        row.configuration[FormRowDescriptor.Configuration.Options] = [1, 2]
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "titleLabel.textColor" : UIColor.whiteColor(), "segmentedControl.tintColor" : UIColor.orangeColor()]
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
        row.configuration[FormRowDescriptor.Configuration.Options] = self.countriesId
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "titleLabel.textColor" : UIColor.whiteColor()]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] =
            { value in
                switch (value)
                {
                default:
                    return self.countriesValue[value as! Int]
                }
            } as TitleFormatterClosure
        section1.addRow(row)
        
        // Password
        let section2 = FormSectionDescriptor()
        
        section2.footerTitle = "Nous avons besoin de votre mot de passe pour enregistrer les changements sur votre profil"
        row = FormRowDescriptor(tag: "password", rowType: .Password, title: "Mot de passe")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), "titleLabel.textColor" : UIColor.whiteColor(), "textField.textColor" : UIColor.orangeColor()]
        section2.addRow(row)
        
        // Submit
        let section3 = FormSectionDescriptor()

        row = FormRowDescriptor(tag: "submit", rowType: .Button, title: "Submit")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["backgroundColor" : UIColor.orangeColor(), "titleLabel.textColor" : UIColor.whiteColor()]
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.formSubmitted()
        } as DidSelectClosure
        section3.addRow(row)
        
        form.sections = [section1, section2, section3]
        self.form = form
    }
}
