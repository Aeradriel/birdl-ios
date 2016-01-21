//
//  EventListTableViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 21/01/2016.
//  Copyright © 2016 Birdl. All rights reserved.
//

import UIKit

class EventListTableViewController: UITableViewController, UISearchBarDelegate
{
    var future: Bool = true
    var events: [Event] = []
    var event: Event!
    var selectedEvent: [EventRow] = []
    var searchResult: [Event] = []
    var searchBar: UISearchBar = UISearchBar()
    
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "EventResultTableViewCell", bundle:nil)
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventResultTableViewCell")
        
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchBar
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        Event.all(self.future, errorHandler: self.errorHandler, successHandler: self.eventsRetrieved)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
        Event.all(self.future, errorHandler: self.errorHandler, successHandler: self.eventsRetrieved)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "eventDetailsSegue")
        {
            let destinationVc: EventDetailViewController = segue.destinationViewController as! EventDetailViewController
            
            destinationVc.event = event
            destinationVc.rows = self.selectedEvent
        }
    }
    
    //MARK: Callbacks
    func errorHandler(error: String)
    {
        let message = "Impossible de récupérer la liste des événements\n" + error
        
        UIAlertView(title: "Erreur", message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func eventsRetrieved(events: [Event])
    {
        self.events = events
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewController delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
        if self.searchBar.text != ""
        {
            return self.searchResult.count
        }
        else
        {
            return self.events.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventResultTableViewCell", forIndexPath: indexPath) as! EventResultTableViewCell
        
        if self.searchBar.text != ""
        {
            cell.name!.text = self.searchResult[indexPath.row].name
            cell.slotsLabel!.text = "\(self.searchResult[indexPath.row].users.count)/\(self.searchResult[indexPath.row].maxSlots) places occupées"
            return cell
        }
        else
        {
            cell.name!.text = self.events[indexPath.row].name
            cell.slotsLabel!.text = "\(self.events[indexPath.row].users.count)/\(self.events[indexPath.row].maxSlots) places occupées"
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedEvent = self.events[indexPath.row]
        
        self.event = events[indexPath.row]
        self.selectedEvent = []
        self.selectedEvent.append(EventBannerRow(imagePath: "bowling"))
        if selectedEvent.desc != nil
        {
            self.selectedEvent.append(EventDescRow(desc: selectedEvent.desc!))
        }
        self.selectedEvent.append(EventAddressRow(nbr: 47, street: "Rue du Coq", zipcode: "98400", city: "Trouville sur Siennes"))
        self.selectedEvent.append(EventMapRow(nbr: 47, street: "Rue du Coq", zipcode: "98400", city: "Trouville sur Siennes"))
        self.selectedEvent.append(EventUsersInfoRow(_registered: false, _nbrRegistered: selectedEvent.minSlots, _maxRegistered: selectedEvent.maxSlots))
        self.selectedEvent.append(EventActionsRow(_registered: false, _nbrRegistered: selectedEvent.minSlots, _maxRegistered: selectedEvent.maxSlots))
        self.hidesBottomBarWhenPushed = true
        performSegueWithIdentifier("eventDetailsSegue", sender: self)
        self.hidesBottomBarWhenPushed = false
    }
    
    //MARK: UISearchBar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchResult.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", self.searchBar.text!)
        let array = (self.events as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.searchResult = array as! [Event]
        
        self.tableView.reloadData()
    }
}
