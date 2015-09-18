//
//  MessagesListTableViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 09/07/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class MessagesListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var relations: [[String : AnyObject]] = []
    var selectedRelation: [String : AnyObject]!
 
    //MARK: UIViewController methods
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RelationTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "relationTableViewCell")
        self.tableView.rowHeight = 75
        self.tableView.tableFooterView = UIView()
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.relations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("relationTableViewCell") as! RelationTableViewCell

        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        cell.name?.textColor = UIColor.whiteColor()
        cell.lastMessage?.textColor = UIColor.whiteColor()
        cell.name?.text = self.relations[indexPath.row]["name"] as? String
        //TODO: Dynamic
        cell.lastMessage?.text = "Apercu du dernier message envoyé dans la conversation"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.selectedRelation = self.relations[indexPath.row]
        performSegueWithIdentifier("messagesSegue", sender: self)
    }
}
