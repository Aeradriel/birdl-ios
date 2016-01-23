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
    
    @IBOutlet weak var starRating: HCSStarRatingView!
    
    @IBOutlet weak var imagePickerButton: UILabel!
    
    
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
            self.eventAddress.text = "There is no address for this event"
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
        if (self.event.date != nil && self.event.date.isLessThanDate(today)) {
            
            self.event.wasUserPresent();
            // was user present = true
            self.eventDate.text = dateString + " - This event is passed";
            self.eventUsersInfo.text = "You were present to this event";
            eventRegisterButton.setTitle("Rate this event", forState: .Normal)
            
            
            
            
        }
        else {
            if (self.event.belongsToCurrentUser == true) {
                self.eventRegisterButton.hidden = true;
                
            }
            else if (self.event.isCurrentUserRegistered()) {
                self.eventRegisterButton.hidden = true;
            }
            else {
                if (self.event.users.count == 0) {
                    eventRegisterButton.setTitle("Be the first", forState: .Normal)
                }
                else if (self.event.users.count == 1) {
                    eventRegisterButton.setTitle("Join him", forState: .Normal)
                }
                else {
                    self.eventRegisterButton.setTitle("Join them !", forState: .Normal)
                    self.eventRegisterButton.hidden = false;
                }
            }
        
            if (self.event.belongsToCurrentUser == true) {
                print("toto1")
                self.eventUsersInfo.text = "\(self.event.users.count) / " + String(self.event.maxSlots) + " People registered.";
                self.eventRegistrationInfo.text = "You created this event."
            }
            else if (self.event.isCurrentUserRegistered()) {
                print("toto4")
                self.eventUsersInfo.text = "\(self.event.users.count) / " + String(self.event.maxSlots) + " People registered.";
                self.eventRegistrationInfo.text = "You are registered to this event."
            }
            else {
                print("toto3")
                self.eventUsersInfo.text = "\(self.event.users.count) / " + String(self.event.maxSlots) + " People registered to this event";
                self.eventRegistrationInfo.hidden = true
            }
        }
        
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
            
            let alertController = UIAlertController(title: "Save Event ?", message: "Do you yant to save this event in your calendar ?", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
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
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
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
        if (self.event.date != nil && self.event.date.isLessThanDate(today)) {
            MBProgressHUD.showHUDAddedTo( self.view , animated: true)
            self.event.rate(Int(self.starRating.value)) { (response, data, error) -> Void in
                MBProgressHUD.hideHUDForView( self.view , animated: true)
                let alert = UIAlertController(title: "Alert", message: "Thanks for your rating !", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        else {
            MBProgressHUD.showHUDAddedTo( self.view , animated: true)
            Event.register(event.id, errorHandler: errorRegister) { () -> Void in
                MBProgressHUD.hideHUDForView( self.view , animated: true)
                print("success")
                
            }
        }
    }
    
    func errorRegister(result: String) {
        MBProgressHUD.hideHUDForView( self.view , animated: true)
        print("error")
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
    

