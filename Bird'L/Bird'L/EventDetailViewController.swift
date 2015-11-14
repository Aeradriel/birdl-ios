//
//  EventDetailViewController.swift
//  Bird'L
//
//  Created by Thibaut Roche on 28/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RFQuiltLayoutDelegate
{
    
    //MARK: Instance variables
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var event: Event!
    var rows: [EventRow] = []
    var aTitle: String!
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let layout = RFQuiltLayout()
        layout.blockPixels = CGSizeMake(self.collectionView.bounds.size.width,self.collectionView.bounds.size.height / 5.0) //default
        layout.delegate = self;
        self.collectionView.setCollectionViewLayout(layout, animated: false);
        var nibName = UINib(nibName: "EventBannerCell", bundle:nil)
        
        self.collectionView.registerNib(nibName, forCellWithReuseIdentifier: "EventBannerTableViewCell")
        nibName = UINib(nibName: "EventDescCell", bundle:nil)
        self.collectionView.registerNib(nibName, forCellWithReuseIdentifier: "EventDescTableViewCell")
        nibName = UINib(nibName: "EventAddressCell", bundle:nil)
        self.collectionView.registerNib(nibName, forCellWithReuseIdentifier: "EventAddressTableViewCell")
        nibName = UINib(nibName: "EventMapCell", bundle:nil)
        self.collectionView.registerNib(nibName, forCellWithReuseIdentifier: "EventMapTableViewCell")
        self.navigationBar.topItem!.title = self.aTitle;
    }
    
    func setEventTitle(title: String) {
        self.aTitle = title;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    //MARK: UITableViewController delegate
    func numberOfSectionsInCollectioneView(tableView: UICollectionView) -> Int
    {
        return 1
    }
        
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.rows[indexPath.row].cellIdentifier, forIndexPath: indexPath) as! EventDetailCollectionViewCell
        
        cell.fillCell(self.rows[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("rows count");
        print(self.rows.count)
        return self.rows.count
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("rows size");
        if (indexPath.row % 2 == 0) {
            return CGSizeMake(100, 50);
        }
        
        return CGSizeMake(50, 50);
        
    }
}
