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
    var userEvents: [Event] = []
    var event: Event!
    var selectedEvent: [EventRow] = []
    var searchResult: [Event] = []
    var userEventsSearchResult: [Event] = []
    var searchBar: UISearchBar = UISearchBar()
    var parent: EventSearchViewController?
    
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
        Event.all(self.future, userEvents: true, errorHandler: self.errorHandler, successHandler: self.eventsUserRetrieved)
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
    
    func eventsUserRetrieved(events: [Event])
    {
        self.userEvents = events
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewController delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? "Événements auxquels je participe" : "Tous les événements"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.searchBar.text != ""
        {
            return section == 0 ? self.userEventsSearchResult.count : self.searchResult.count
        }
        else
        {
            return section == 0 ? self.userEvents.count : self.events.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventResultTableViewCell", forIndexPath: indexPath) as! EventResultTableViewCell
        
        if self.searchBar.text != ""
        {
            let event = indexPath.section == 0 ? self.userEventsSearchResult[indexPath.row] : searchResult[indexPath.row]
            
            cell.name!.text = event.name
            cell.slotsLabel!.text = "\(event.users.count)/\(event.maxSlots) places occupées"
            return cell
        }
        else
        {
            let event = indexPath.section == 0 ? self.userEvents[indexPath.row] : events[indexPath.row]
            
            cell.name!.text = event.name
            cell.slotsLabel!.text = "\(event.users.count)/\(event.maxSlots) places occupées"
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
        if parent != nil
        {
            self.parent?.showEvent(event, rows: self.selectedEvent)
        }
    }
    
    //MARK: UISearchBar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchResult.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", self.searchBar.text!)
        let array = (self.events as NSArray).filteredArrayUsingPredicate(searchPredicate)
        let array2 = (self.userEvents as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.searchResult = array as! [Event]
        self.searchResult = array2 as! [Event]
        
        self.tableView.reloadData()
    }
}
