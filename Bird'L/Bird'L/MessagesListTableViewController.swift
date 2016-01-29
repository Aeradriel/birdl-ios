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
        self.tableView.estimatedRowHeight = 110
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tabBarController?.navigationItem.title = self.title
        MBProgressHUD.showHUDAddedTo( self.view , animated: true)
        User.relations(errorHandler: self.errorHandler, successHandler: self.relationsDidLoad)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
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
        MBProgressHUD.hideHUDForView( self.view , animated: true)
    }
    
    func errorHandler(error: String)
    {
        UIAlertView(title: NSLocalizedString("error", comment: ""), message: error, delegate: nil, cancelButtonTitle: "OK").show()
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

        cell.backgroundColor = UIColor.clearColor()
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
