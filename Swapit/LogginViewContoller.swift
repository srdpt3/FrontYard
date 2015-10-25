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
        
        self.logInView?.logo = UIImageView(image: UIImage(named: "vendee_logo_white"))
        // self.signUpController?.signUpView?.logo = UIImageView(image: UIImage(named: "main.gif"))
        self.logInView!.logo?.contentMode = .Center
        self.logInView!.logo?.contentMode = UIViewContentMode.ScaleAspectFit
        // self.signUpController?.signUpView?.logo?.contentMode = UIViewContentMode.Center
        
        self.logInView?.signUpButton?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
        self.logInView?.signUpButton?.addTarget(self, action: "displaySignUpbutton", forControlEvents: UIControlEvents.TouchUpInside)
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "VendeeSplash3")!)
        
        
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        
        
        let mainScreenSize : CGSize = UIScreen.mainScreen().bounds.size
        let imageObbj:UIImage! =   self.imageResize(UIImage(named: "b80264c12c88eac19d5e4c8597d051e1.jpg")!, sizeChange: CGSizeMake(mainScreenSize.width, mainScreenSize.height))
        self.view.backgroundColor = UIColor(patternImage:imageObbj)
        
        
        
        // make the buttons classier
        //  customizeButton(logInView?.facebookButton!)
        //  customizeButton(logInView?.twitterButton!)
        customizeButton(logInView?.signUpButton!)
        
        
        
        
        
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
        
        if PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue == true
        {
            
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
        else {
            
            let alert = UIAlertController(title: "Error", message: "Please verify your email ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
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
        
        // let currentUser = PFUser.currentUser()!
        
        if PFUser.currentUser() != nil
        {
            
            if PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue == true
            {
                
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
            
            //JTSplashView.splashViewWithBackgroundColor(nil, circleColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), circleSize: nil)
            
        }
        
    }
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    override func viewWillDisappear(animated: Bool) {
        
        
    }
    
    
}