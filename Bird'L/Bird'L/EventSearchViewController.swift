//
//  EventSearchViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tinyTabBar: TinyTabBar!
    
    var events: [Event] = []
    var event: Event!
    var selectedEvent: [EventRow] = []
    var searchResult: [Event] = []
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    //MARK: UIViewController functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "EventResultTableViewCell", bundle:nil)
        
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "EventResultTableViewCell")
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tinyTabBar.tabs = [["title" : "Future", "controller" : UIViewController()], ["title" : "Past", "controller" : UIViewController()]]
        self.tinyTabBar.backgroundColor = self.navigationController?.navigationBar.barTintColor
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
        Event.all(true, errorHandler: self.errorHandler, successHandler: self.eventsRetrieved)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.resultSearchController.active
        {
            return self.searchResult.count
        }
        else
        {
            return self.events.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventResultTableViewCell", forIndexPath: indexPath) as! EventResultTableViewCell
        
        if (self.resultSearchController.active)
        {
            cell.name!.text = self.searchResult[indexPath.row].name
            cell.name!.text = "\(self.searchResult[indexPath.row].users.count)/\(self.searchResult[indexPath.row].maxSlots) places occupées"
            return cell
        }
        else
        {
            cell.name!.text = self.events[indexPath.row].name
            cell.slotsLabel!.text = "\(self.events[indexPath.row].users.count)/\(self.events[indexPath.row].maxSlots) places occupées"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
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
    
    //MARK: UISearchResultsUpdating delegate
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchResult.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", self.resultSearchController.searchBar.text!)
        let array = (self.events as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.searchResult = array as! [Event]
        
        self.tableView.reloadData()
    }
}
