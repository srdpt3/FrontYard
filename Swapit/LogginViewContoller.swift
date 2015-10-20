//
//  LogginViewContoller.swift
//  Swapit
//
//  Created by Dustin Yang on 8/11/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import FoldingTabBar


class LogginViewContoller: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        let nav = self.navigationController?.navigationBar
        self.navigationItem.title = "Welcome"
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.logInView?.logo = UIImageView(image: UIImage(named: "vendee_logo.png"))
        // self.signUpController?.signUpView?.logo = UIImageView(image: UIImage(named: "main.gif"))
        self.logInView!.logo?.contentMode = .Center
        self.logInView!.logo?.contentMode = UIViewContentMode.ScaleAspectFit
        // self.signUpController?.signUpView?.logo?.contentMode = UIViewContentMode.Center
        
        self.logInView?.signUpButton?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
        self.logInView?.signUpButton?.addTarget(self, action: "displaySignUpbutton", forControlEvents: UIControlEvents.TouchUpInside)
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "VendeeSplash3")!)

        
    }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        let installation:PFInstallation = PFInstallation.currentInstallation()
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

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overViewVC = sb.instantiateViewControllerWithIdentifier("loaddataViewController") as! loaddataViewController
        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(overViewVC, animated: true)
        
        
    }
    
    
    func displaySignUpbutton()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signUPVC = sb.instantiateViewControllerWithIdentifier("signupVC") as! SignUpTableViewController
        //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(signUPVC, animated: true)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        imagesToswipe.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        
        
        
        if PFUser.currentUser() != nil
        {
            //JTSplashView.splashViewWithBackgroundColor(nil, circleColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), circleSize: nil)
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    PFUser.currentUser()!.setValue(geoPoint, forKey: "location")
                    PFUser.currentUser()!.saveInBackground()
                }
            }
            
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let overViewVC = sb.instantiateViewControllerWithIdentifier("loaddataViewController") as! loaddataViewController
            //     overViewVC.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(overViewVC, animated: true)
            
            
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
    }
    
    
}