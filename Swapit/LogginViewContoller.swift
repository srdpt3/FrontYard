//
//  LogginViewContoller.swift
//  Swapit
//
//  Created by Dustin Yang on 8/11/15.
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

class LogginViewContoller: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //self.signUpController?.delegate = self
        self.logInView?.logo = UIImageView(image: UIImage(named: "main.gif"))
       // self.signUpController?.signUpView?.logo = UIImageView(image: UIImage(named: "main.gif"))
        self.logInView!.logo?.contentMode = .Center
       // self.signUpController?.signUpView?.logo?.contentMode = UIViewContentMode.Center
        
        self.logInView?.signUpButton?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
        
        self.logInView?.signUpButton?.addTarget(self, action: "displaySignUpbutton", forControlEvents: UIControlEvents.TouchUpInside)
        
     //   let loader = LiquidLoader(frame: CGRectMake(100, 100, 100, 100), effect: .GrowCircle(UIColor.whiteColor()))
        //    var loader = LiquidLoader(frame: CGRectMake(0, 0, koloda.frame.size.width, koloda.frame.size.height), effect: .GrowCircle(UIColor.whiteColor()))
        
        imagesToswipe.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)

        if PFUser.currentUser() != nil
        {
            
            showChatOverview()
            
        }

    }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        var installation:PFInstallation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()


        installation.saveInBackgroundWithBlock(nil)
            showChatOverview()
    }
    
    //  No need for this part if not using PARSE signup   -Dustin Yang
    /*
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: { () -> Void in
            var installation:PFInstallation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.saveInBackgroundWithBlock(nil)
            
            self.showChatOverview()
            
        })
 
    }*/
    func showChatOverview()
    {
        /*
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overViewVC = sb.instantiateViewControllerWithIdentifier("ChatOverView") as! OverViewTableViewController
        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(overViewVC, animated: true)
        */


        //JTSplashView.splashViewWithBackgroundColor(nil, circleColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), circleSize: nil)
        

        
        
        imagesToswipe.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        var query:PFQuery = PFQuery(className: "imageUpload")
        query.addAscendingOrder("createdAt")
        query.whereKey("user", notEqualTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
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
              
                                
                          
                                
                              //  JTSplashView.finishWithCompletion { () -> Void in
                                    
                                    println("imagesToswipe.countasdfasd")

                                   let sb = UIStoryboard(name: "Main", bundle: nil)
                                  let overViewVC = sb.instantiateViewControllerWithIdentifier("tableMainView") as! YALFoldingTabBarController
                                    overViewVC.navigationItem.setHidesBackButton(true, animated: false)
                              self.navigationController?.presentViewController(overViewVC, animated: true,completion:nil)
  

                                    
                                    
                                  //  UIApplication.sharedApplication().statusBarHidden = true
                               // }
                                
                                
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
        
        

            
        
        
      //  self.parentViewController?.presentViewController(overViewVC, animated: true, completion: nil)

    


    }
  

    func displaySignUpbutton()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signUPVC = sb.instantiateViewControllerWithIdentifier("signupVC") as! SignUpTableViewController
      //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(signUPVC, animated: true)
        
        
    }
    
    func setupYALTabBarController()
    {
        
        //YALFoldingTabBarController *tabBarController = (YALFoldingTabBarController *) self.window.rootViewController;
        //
      //  var tabBarController: YALFoldingTabBarController = self.view.window?.rootViewController as! YALFoldingTabBarController
        
        // var tabBarController: YALFoldingTabBarController =
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setup()
        appDelegate.window?.rootViewController  = appDelegate.tabBarController
        appDelegate.tabBarController.selectedIndex = 1;
    }

    override func viewWillDisappear(animated: Bool) {
        

    }
    
    
}
