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
var pricelabel = [String]()
var itemTitle = [String]()
var itemDesc = [String]()
var imagesToswipe = [UIImage]()
var numberOfCards: UInt = UInt(imagesToswipe.count)


class loaddataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        imagesToswipe.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        var query:PFQuery = PFQuery(className: "imageUpload")
        query.addAscendingOrder("createdAt")
        query.whereKey("user", notEqualTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                
                ViewControllerUtils().showActivityIndicator(self.view)
                
                
                let objects = results as! [PFObject]
                for obj in objects{
                    let thumbNail = obj["image"] as! PFFile
                    thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) -> Void in
                        
                        if error2 == nil
                        {
                            let image = UIImage(data:imageData!)
                            //image object implementation
                            imagesToswipe.append(image!)
                            var objId = obj.objectId! as String
                            otherObjID.append(objId)
                            
                            
                            
                            
                            if(objects.count == imagesToswipe.count ){
                                
                                
                                println("imagesToswipe.count \(imagesToswipe.count)")
                                numberOfCards = UInt(imagesToswipe.count)
                                
                                
                                
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let overViewVC = sb.instantiateViewControllerWithIdentifier("tableMainView") as! YALFoldingTabBarController
                                overViewVC.navigationItem.setHidesBackButton(true, animated: false)
                                self.navigationController?.presentViewController(overViewVC, animated: true,completion:nil)
                                
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    })
                    
                }
                
                
            }
            else
            {
                println("erorr in getfavoritelist ")
            }
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        
     //   nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        // nav?.backgroundColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        
        var followButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
        //followButton.setTitle(" Swit", forState: UIControlState.Normal)
        followButton.setImage(UIImage(named: "mainlogo.png.gif"), forState: UIControlState.Normal)
        followButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 25.0)
        followButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
        followButton.addTarget(self, action: "FrontYard:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.navigationItem.titleView = followButton
        self.tabBarController?.tabBar.hidden = false
        
        
        
        
    }

    override func viewDidDisappear(animated: Bool) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setup()
        appDelegate.window?.rootViewController  = appDelegate.tabBarController
        appDelegate.tabBarController.selectedIndex = 1;
        
        //  actInd.stopAnimating()
    }


}
