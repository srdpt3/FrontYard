//
//  loaddataViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 9/15/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import FoldingTabBar
var otherImageFiles = [PFFile]()
var otherObjID = [String]()
var otherUsers = [String]()
//var pricelabel = [String]()
var itemTitle = [String]()
var itemDesc = [String]()
var imagesToswipe = [UIImage]()
var itemPrice = [Int]()
var numberOfCards: UInt = UInt(imagesToswipe.count)
var minPrice : Int!
var maxPrice : Int!



class loaddataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        CozyLoadingActivity.Settings.CLASuccessText = ""
        CozyLoadingActivity.Settings.CLASuccessIcon = ""
        CozyLoadingActivity.Settings.CLATextColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        CozyLoadingActivity.Settings.CLAActivityColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        CozyLoadingActivity.show("Loading...", sender: self, disableUI: false)
        
        let nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //   nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        // nav?.backgroundColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        
        let followButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
        //followButton.setTitle(" Swit", forState: UIControlState.Normal)
        followButton.setImage(UIImage(named: "mainlogo.png.gif"), forState: UIControlState.Normal)
        followButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 25.0)
        followButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
        followButton.addTarget(self, action: "FrontYard:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.navigationItem.titleView = followButton
        self.tabBarController?.tabBar.hidden = false

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        let currentUser = PFUser.currentUser()!
        minPrice = currentUser["minPrice"] as! Int
        maxPrice = currentUser["maxPrice"] as! Int
        //currentUser["profileImage"] = profileImagefile
            

         loaditems()


        
    }

    override func viewDidDisappear(animated: Bool) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setup()
        appDelegate.window?.rootViewController  = appDelegate.tabBarController
        appDelegate.tabBarController.selectedIndex = 1;
        
        //  actInd.stopAnimating()
    }

    func loaditems()
    {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                PFUser.currentUser()!.setValue(geoPoint, forKey: "location")
                PFUser.currentUser()!.saveInBackground()

                let query = PFUser.query()!
                query.whereKey("location", nearGeoPoint:geoPoint!)
                query.whereKey("username",notEqualTo: PFUser.currentUser()!.username!)
                query.limit = 100
                
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    if error == nil
                    {
                        print(users!.count)
                    //    for usr in user {
                            imagesToswipe.removeAll(keepCapacity: false)
                            itemPrice.removeAll(keepCapacity: false)
                            otherObjID.removeAll(keepCapacity: false)
                            let query2:PFQuery = PFQuery(className: "imageUpload")
  
                            query2.whereKey("price", greaterThanOrEqualTo: minPrice)
                            query2.whereKey("price", lessThanOrEqualTo: maxPrice)
                            query2.addAscendingOrder("createdAt")
                         //   query2.whereKey("user", equalTo: usr)
                            query2.whereKey("user",notEqualTo: PFUser.currentUser()!)
                            query2.whereKey("Block",notEqualTo: PFUser.currentUser()!.username!)

                            query2.whereKey("user", containedIn: users as! [PFUser])
                            query2.whereKey("passed", notEqualTo: PFUser.currentUser()!.username!)
                            query2.whereKey("interesting", notEqualTo: PFUser.currentUser()!.username!)
                            query2.whereKey("chat", notEqualTo: PFUser.currentUser()!.username!)
                        

                            query2.findObjectsInBackgroundWithBlock { (results, error2) -> Void in
                                if error2 == nil
                                {
                                    print("results!.count\(results!.count)")
                                    if (results!.count == 0)
                                    {
                                        CozyLoadingActivity.hide(success: true, animated: true)
                                        let sb = UIStoryboard(name: "Main", bundle: nil)
                                        let overViewVC = sb.instantiateViewControllerWithIdentifier("tableMainView") as! YALFoldingTabBarController
                                        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
                                        self.navigationController?.presentViewController(overViewVC, animated: true,completion:nil)
                                        
                                    }
                                    else{
  
                                        
                                        let objects = results as! [PFObject]
                                        for obj in objects{
                                            let pricelabel = obj["price"]!
                                            let thumbNail = obj["image"] as! PFFile
                                            thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) ->
                                                Void in
                                                if error2 == nil
                                                {
                                                    let image = UIImage(data:imageData!)
                                                    imagesToswipe.append(image!)
                                                    itemPrice.append(Int(pricelabel as! NSNumber))

                                                    let objId = obj.objectId! as String
                                                    otherObjID.append(objId)
                                                    if(results!.count == imagesToswipe.count ){
                                                        
                                                        numberOfCards = UInt(imagesToswipe.count)
                                                        
                                                         CozyLoadingActivity.hide(success: true, animated: true)
                                                        let sb = UIStoryboard(name: "Main", bundle: nil)
                                                        let overViewVC = sb.instantiateViewControllerWithIdentifier("tableMainView") as! YALFoldingTabBarController
                                                        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
                                                     //   self.navigationController?.presentViewController(overViewVC, animated: true,completion:nil)
                                                        
                                                        let transition : CATransition = CATransition()
                                                        transition.duration = 1
                                                        transition.type = kCATransitionFade;
                                                        transition.subtype = kCATransitionFromTop;
                                                        
                                                        self.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
                                                        self.navigationController!.presentViewController(overViewVC, animated: true,completion:nil)

                                                    }
                                                    
                                                }
                                                
                                            })
                                            
                                        }

                                    }
                                    
                                }
                                else
                                {
                                    print("erorr in getfavoritelist ")
                                }
                        }
                        
                        
                    }
                    
                    
                })


            }
        }

    }
    

}
