//
//  EventViewController.swift
//  Bird'L
//
//  Created by Pierre-Olivier Maugis on 31/12/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import Foundation

//
//  EventDetailViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK: Instance variables
    
    var event: Event!
    var rows: [EventRow] = []
    
    @IBOutlet weak var eventBanner: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!

    @IBOutlet weak var eventDesc: UILabel!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var eventMap: MKMapView!
    
    @IBOutlet weak var eventUsersInfo: UILabel!
    
    @IBOutlet weak var eventRegistrationInfo: UILabel!

    @IBOutlet weak var eventRegisterButton: UIButton!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventDateTableViewCell: UITableViewCell!
    
    @IBOutlet weak var eventUsersInfoTableViewCell: UITableViewCell!
    
    @IBOutlet weak var imagePickerButton: UILabel!
    
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    
    let imagePicker = UIImagePickerController()
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.eventTitle.text = self.event.name
        self.eventDesc.text = self.event.desc
        if (self.event.location?.characters.count <= 0) {
            self.eventAddress.text = NSLocalizedString("no_address_for_event", comment: "")
        }
        else {
            self.eventAddress.text = self.event.location
        }
        
        
        self.eventDateTableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.eventUsersInfoTableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        
        
        let dateFormatter = NSDateFormatter()
        var dateString = ""
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        
        if self.event.date != nil {
            dateString = dateFormatter.stringFromDate(self.event.date)

            self.eventDate.text = dateString
        }
        
        let today = NSDate();
        
        
        if (self.event.belongsToCurrentUser == true) {
            self.eventRegisterButton.hidden = true;
            
            self.eventRegistrationInfo.text = NSLocalizedString("you_created_event", comment: "")
            
        }
        else if (self.event.isCurrentUserRegistered()) {
            if (self.event.date != nil && !self.event.date.isLessThanDate(today)) {
                eventRegisterButton.setTitle("Unregister", forState: .Normal)
                self.eventRegistrationInfo.hidden = true
            }
            else {
                self.eventRegisterButton.hidden = false
                self.eventRegisterButton.setTitle("Rate this event", forState: .Normal)
                self.eventRegistrationInfo.text = ""
            }
        }
        else if (self.event.maxSlots <= self.event.users.count) {
            self.eventRegisterButton.hidden = true
            self.eventRegistrationInfo.text = "There is no more places left for this event."
            self.eventRegistrationInfo.hidden = false
        }
        else {
            if (self.event.users.count == 0) {
                eventRegisterButton.setTitle(NSLocalizedString("be_the_first", comment: ""), forState: .Normal)
            }
            else if (self.event.users.count == 1) {
                eventRegisterButton.setTitle(NSLocalizedString("join_him", comment: ""), forState: .Normal)
            }
            else {
                self.eventRegisterButton.setTitle(NSLocalizedString("join_them", comment: ""), forState: .Normal)
                self.eventRegisterButton.hidden = false;
            }
            self.eventRegistrationInfo.hidden = true
        }
        self.eventUsersInfo.text = "\(self.event.users.count) / " + String(self.event.maxSlots) + " " + NSLocalizedString("registered", comment: "");
        
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.event.location!, completionHandler: ({
            (placemarks, error) in
            
            if placemarks != nil && placemarks!.count > 0
            {
                let topResult = placemarks!.first
                let placemark = MKPlacemark(placemark: topResult!)
                var region = self.eventMap.region
                
                region.center = (placemark.region as! CLCircularRegion).center
                region.span.longitudeDelta = 0.25 / 111
                region.span.latitudeDelta = 0.25 / 111
                
                self.eventMap.setRegion(region, animated: true)
                self.eventMap.addAnnotation(placemark)
                self.eventMap.zoomEnabled = true

            }
        }))

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showEventUsers") {
            let vc = segue.destinationViewController as! EventUsersViewController
            vc.event = self.event
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == 4)
        {
            
            let alertController = UIAlertController(title: NSLocalizedString("save_event", comment: ""), message: NSLocalizedString("save_event_in_calendar", comment: ""), preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                let eventStore : EKEventStore = EKEventStore()
                
                eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                    (granted, error) in
                    
                    if (granted) && (error == nil) {
                        let event:EKEvent = EKEvent(eventStore: eventStore)
                        
                        event.title = self.event.name
                        event.startDate = self.event.date
                        event.endDate = self.event.date.dateByAddingTimeInterval(NSTimeInterval.init(floatLiteral: 3600))
                        event.notes = self.event.desc
                        event.location = self.event.location
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        
                        do {
                            try eventStore.saveEvent(event, span: EKSpan.ThisEvent)
                        } catch _ {
                            print("error saving event in calendar")
                        }
                        
                    } 
                })

            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }

    @IBAction func eventRegisterButtonPressed(sender: AnyObject) {
        let today = NSDate();
        if (self.event.date != nil && !self.event.date.isLessThanDate(today) && event.isCurrentUserRegistered()) {
            MBProgressHUD.showHUDAddedTo(self.view , animated: true)
            self.event.unregister() { (response, data, error) in
                self.reload()
                MBProgressHUD.hideHUDForView( self.view , animated: true)
            }
        } else if (self.event.date != nil && self.event.date.isLessThanDate(today)) {
            User.rate(Int(self.starRatingView.value), user: self.event.owner!, event: self.event, completion: { (response, data, error) -> Void in
                if error != nil {
                    let message = "Une erreur est survenue lors de la notation."
                    
                    UIAlertView(title: "Erreur", message: message, delegate: nil, cancelButtonTitle: "OK").show()
                    self.starRatingView.enabled = false
                    self.eventRegisterButton.setTitle("", forState: .Normal)
                } else {
                    let message = "Vous avez noté l'organisateur avec succès !"
                    
                    UIAlertView(title: "Succès", message: message, delegate: nil, cancelButtonTitle: "OK").show()
                }
            })
        }
        else {
            MBProgressHUD.showHUDAddedTo( self.view , animated: true)
            Event.register(event.id, errorHandler: errorRegister) { () -> Void in
                self.reload()
                MBProgressHUD.hideHUDForView( self.view , animated: true)
            }
        }
    }
    
    func reload() {
        self.event.reload() { (response, data, error) in
            if (data != nil) {
                self.viewDidLoad()
                self.viewDidAppear(true)
            }
        }
    }
    
    func errorRegister(result: String) {
        MBProgressHUD.hideHUDForView( self.view , animated: true)
        self.reload()
        print(result)
    }
    
    @IBAction func loadImageButtonTapped(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.eventBanner.contentMode = .ScaleAspectFit
            self.eventBanner.image = pickedImage
            self.eventBanner.contentMode = UIViewContentMode.ScaleAspectFill;
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
        
}
    

