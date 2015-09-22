//
//  ChooseTableViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/12/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit

class ChooseTableViewController: PFQueryTableViewController , UISearchBarDelegate{

    @IBOutlet var searchBar: UISearchBar!
    var searchString = ""
    var searchInProgress = false
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    

    }

    override func queryForTable() -> PFQuery {
        let query = PFUser.query()
        let currentUser = PFUser.currentUser()?.username!
   
       query?.whereKey("username", notEqualTo: currentUser!)
        
        if searchInProgress
        {
            query?.whereKey("username", containsString: searchString)
        }
        
        print(self.objects!.count)
        
        if self.objects!.count == 0
        {
            
            query!.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        return query!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    //    tabBarController2.tabBarView.hidden = true
        
        
        
        
        if PFUser.currentUser() != nil{
        let user1 = PFUser.currentUser()!
        let user2 = self.objects?[indexPath.row] as! PFUser
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let messageVC = sb.instantiateViewControllerWithIdentifier("MessageViewController") as? MessageViewController
            
            
            
        var room = PFObject(className: "Room")
        
        let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
        let roomQuery = PFQuery(className:"Room", predicate: pred)
            roomQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil
            {
                if results!.count > 0
                {
                    room = results?.last as! PFObject
                    messageVC!.room = room
                    messageVC?.incomingUser = user2
                    self.navigationController?.pushViewController(messageVC!, animated: true)

                }
                else
                {
                    room["user1"] = user1
                    room["user2"] = user2
                    
                    room.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil{
                            messageVC!.room = room
                            messageVC?.incomingUser = user2
                            
                         self.navigationController?.pushViewController(messageVC!, animated: true)

                        }
                        
                    })
                }
                
                
            }
            
        })
        }
        
    }
    

    
    //Will Move searchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        searchInProgress = true
        self.loadObjects()
        searchInProgress = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func extraLeftItemDidPressed()
    {
        
        //print("left oressss")
        
    }
    func extraRightItemDidPressed()
    {
       // println("left oressss")
        
    }

}
