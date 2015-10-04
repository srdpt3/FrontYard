//
//  OverViewTableViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/12/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import FoldingTabBar


class OverViewTableViewController: UITableViewController,YALTabBarInteracting{
    
    @IBOutlet var choosePartnerButoon: UIBarButtonItem!
    @IBOutlet var logout: UIBarButtonItem!
    
    var rooms = [PFObject]()
    var users = [PFUser]()
    var itemObj = [String]()
    var itemImage : [UIImage] = []
     var actInd : UIActivityIndicatorView!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        let nav = self.navigationController?.navigationBar
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationItem.title = "Conversations"
        
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor

         loadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() != nil{
            // self.view.backgroundColor    = UIColor(red: 67.0/255.0, green: 179.0/255.0, blue: 229.0/255.0, alpha: 1)

            
            self.navigationItem.setRightBarButtonItem(choosePartnerButoon, animated: false)
            self.navigationItem.setLeftBarButtonItem(logout, animated: false)
         self.tableView.reloadData()

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayPushMessages:", name: "ds", object: nil)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ds", object: nil)
        
    }
    func extraLeftItemDidPressed()
    {
        
        print("left oressss")
        
    }
    func extraRightItemDidPressed()
    {
        print("left oressss")
        
    }
    
    func displayPushMessages(notification:NSNotification)
    {
        
        let notificationDict = notification.object as? NSDictionary
        
        if let aps = notificationDict?.objectForKey("aps") as? NSDictionary{
            let messageText = aps.objectForKey("alert") as? String
            
            let alert = UIAlertController(title: "New Message", message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Thanks...", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
             loadData()
            self.tableView.reloadData()
        }
        
        
    }
    
    
    @IBAction func settingButtonPressed(sender: AnyObject) {
        
        let SettingactionSheet = UIAlertController(title: "Setting Menu", message: "Select what you want to do", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        SettingactionSheet.addAction(UIAlertAction(title: "Change profile", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = sb.instantiateViewControllerWithIdentifier("signupVC") as! SignUpTableViewController
            profileVC.change = true
            //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(profileVC, animated: true)
            
            
        }))
        
        SettingactionSheet.addAction(UIAlertAction(title: "Upload my item", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let photoUploadVC = sb.instantiateViewControllerWithIdentifier("photoViewController") as! photoUploadPageVC
            //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(photoUploadVC, animated: true)
            
            
        }))
        
        
        SettingactionSheet.addAction(UIAlertAction(title: "Log out", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            PFUser.logOut()
            imagesToswipe.removeAll(keepCapacity: false)
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            
            let logginVC = sb.instantiateViewControllerWithIdentifier("mainViewController") as! mainViewController
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.tabBarController.tabBarView.hidden = true
            
            
            appDelegate.window?.makeKeyAndVisible()
            
            // self.navigationController?.pushViewController(logginVC, animated: true)
            self.parentViewController?.presentViewController(logginVC, animated: true, completion: nil)
            
            
            
            print("logout")
            
        }))
        
        SettingactionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel  , handler: nil))
        self.presentViewController(SettingactionSheet, animated: true, completion: nil)
        
    }
    
    func LogoutButton() {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rooms.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! OverviewTableViewCell
        cell.unreadindicator.hidden = true
 
        let targetUser = users[indexPath.row]
        cell.nameLabel.text = targetUser.username
        
        let user1 = PFUser.currentUser()!
        let user2 = users[indexPath.row]
        
        if(itemObj.count == self.rooms.count)
        {
     
                let query2:PFQuery = PFQuery(className: "imageUpload")
                query2.whereKey("objectId", equalTo: itemObj[indexPath.row] as String)
                
                query2.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if error  == nil
                    {
                        //   print("objects?.count \(objects?.count)")
                        for obj in objects!{
                            
                            
                            let thumbNail2 = obj["image"] as! PFFile
                            
                            thumbNail2.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                                if (error == nil) {
                                    
                                    let image = UIImage(data:imageData!)
                                    cell.profileImageView.image = image
                                  

                                }
                                
                            })
                            
                            
                        }
                        
                    }
                    else
                    {
                        
                        print("errror")
                    }
                    
                }
            // let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
            let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ AND item = %@ OR user1 = %@ AND user2 = %@  AND item = %@ ", user1,user2,self.itemObj[indexPath.row],user2,user1,self.itemObj[indexPath.row])
            let roomQuery = PFQuery(className: "Room", predicate: pred)
            // roomQuery.orderByDescending("updatedAt")
                roomQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
                if error == nil
                {
                    if results!.count > 0
                    {
                        let messageQuery = PFQuery(className: "Message")
                        let room = results?.last as? PFObject
                        

                        let unreadQuery = PFQuery(className: "UnreadMessage")
                        unreadQuery.whereKey("user", equalTo: PFUser.currentUser()!)
                        unreadQuery.whereKey("room", equalTo: room!)
                        unreadQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                            if error == nil
                            {
                                if results!.count > 0{
                                    cell.unreadindicator.hidden = false
                                    
                                }
                                
                            }
                        })
                        
                        
                        messageQuery.whereKey("room", equalTo: room!)
                        messageQuery.limit = 1
                        messageQuery.orderByDescending("updatedAt")
                        messageQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                            if error == nil
                            {
                                if results!.count > 0
                                {
                                    let message = results?.last as? PFObject
                                    // var contentString : NSString! = message["content"] as! NSString!
                                    
                                    cell.lastMessageLabel.text  = message?["content"]  as? String
                                    
                                    
                                    let date = message?.createdAt
                                    let interval = NSDate().daysAfterDate(date)
                                    print("interval\(interval)")
                                    var dateString = ""
                                    
                                    if interval == 0
                                    {
                                        dateString = "today"
                                    }
                                        // }else if interval == 1
                                        //  {
                                        //      dateString = "yesterday"
                                        //  }else if interval > 1
                                        // {
                                    else
                                    {
                                        let dateFormat = NSDateFormatter()
                                        dateFormat.dateFormat = "mm/dd/yyyy"
                                        dateString = dateFormat.stringFromDate(message!.createdAt!)
                                        
                                        
                                    }
                                    cell.dateLabel.text = dateString as? String!
                                }
                                else
                                {
                                    cell.lastMessageLabel.text = "No messages"
                                }
                                
                                
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
            }


            //print(room["item"])
            //cell.profileImageView.image = itemImage[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        //   tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeigh
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let messageVC = sb.instantiateViewControllerWithIdentifier("MessageViewController") as? MessageViewController
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = true
        
        
        let user1 = PFUser.currentUser()!
        let user2 = users[indexPath.row]
        
       // let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
        
    let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ AND item = %@ OR user1 = %@ AND user2 = %@  AND item = %@ ", user1,user2,self.itemObj[indexPath.row],user2,user1,self.itemObj[indexPath.row])
        
        
        
        let roomQuery = PFQuery(className: "Room", predicate: pred)
        roomQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                let room = results!.last as! PFObject
                messageVC!.room = room
                messageVC?.incomingUser = user2
                
                let unreadQuery = PFQuery(className: "UnreadMessage")
                unreadQuery.whereKey("user", equalTo: PFUser.currentUser()!)
                unreadQuery.whereKey("room", equalTo: room)
                unreadQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                    if error == nil
                    {
                        if results!.count > 0{
                            let unreadMessages = results! as? [PFObject]
                            //    println(unreadMessges)
                            for msg in unreadMessages! {
                                msg.deleteInBackgroundWithBlock(nil)
                                
                            }
                            
                            
                        }
                        
                    }
                })
                
                self.navigationController?.pushViewController(messageVC!, animated: true)
                
                //  let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //  appDelegate.window?.rootViewController =  messageVC
                
                // appDelegate.window?.makeKeyAndVisible()
                
                
                
            }
        }
    }
    
    func loadData()
    {
      // timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "endOfWork", userInfo: nil, repeats: true)
        print("load data called")
        rooms = [PFObject]()
        users = [PFUser]()
       // actInd.startAnimating()

        self.itemImage.removeAll(keepCapacity: false)
        self.itemObj.removeAll(keepCapacity: false)

        let pred = NSPredicate(format: "user1 = %@ OR user2 = %@", PFUser.currentUser()!, PFUser.currentUser()!)
        let roomQuery = PFQuery(className: "Room", predicate: pred)
      // roomQuery.orderByAscending("updatedAt")
      roomQuery.orderByAscending("createdAt")
      //  roomQuery.orderBySortDescriptor("updatedAt")
        roomQuery.includeKey("user1")
        roomQuery.includeKey("user2")
        
        roomQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil{
                self.rooms = results as! [PFObject]
                for room in self.rooms{
                    let user1 = room.objectForKey("user1") as! PFUser
                    let user2 = room["user2"] as! PFUser
                    
                    let query2:PFQuery = PFQuery(className: "imageUpload")
                    query2.whereKey("objectId", equalTo: room["item"] as! String!)
    
                    query2.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                        if error  == nil
                        {
                         //   print("objects?.count \(objects?.count)")
                            for obj in objects!{
                                self.itemObj.append(obj.objectId as String!)
                                
                                if(self.itemObj.count == self.rooms.count ){
                                        self.tableView.reloadData()
                                }
                                /*
                                let thumbNail = obj["image"] as! PFFile

                                thumbNail.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                                    if (error == nil) {
                                        
                                        let image = UIImage(data:imageData!)
                                        self.itemImage.append(image!)
                                        
                                        if(self.itemImage.count == self.rooms.count ){
                                          self.tableView.reloadData()
                                         //   self.refreshControl!.endRefreshing()

                                        }

                                        
                                    }
 
                                })*/
                            }
                        }
                            
                        else
                        {
                            
                            print("errror")
                        }
                        
                    }
                    
                    
                    if user1.objectId != PFUser.currentUser()?.objectId
                    {
                        self.users.append(user1)
                    }
                    
                    if user2.objectId != PFUser.currentUser()?.objectId
                    {
                        self.users.append(user2)
                        
                    }
                }
            }
        }
        
    }


    


    
    
    
}