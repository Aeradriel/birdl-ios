//
//  MessagesListTableViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 09/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class MessagesListTableViewController: UITableViewController
{
    var relations: [[String : AnyObject]] = []
    var selectedRelation: [String : AnyObject]!
 
    //MARK: UIViewController methods
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool)
    {
        User.relations(errorHandler: self.errorHandler, successHandler: self.relationsDidLoad)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "messagesSegue")
        {
            let destinationVc: MessagesViewController = segue.destinationViewController as! MessagesViewController
            
            destinationVc.relationId = self.selectedRelation["id"] as! Int
        }
    }
    
    //MARK: Callbacks
    func relationsDidLoad(relations: [[String : AnyObject]])
    {
        self.relations = relations
        self.tableView.reloadData()
    }
    
    func errorHandler(error: String)
    {
        UIAlertView(title: "Erreur", message: error, delegate: nil, cancelButtonTitle: "OK").show()
    }

    //MARK: TableView delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.relations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("relationTableViewCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.relations[indexPath.row]["name"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.selectedRelation = self.relations[indexPath.row]
        performSegueWithIdentifier("messagesSegue", sender: self)
    }
}
