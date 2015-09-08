//
//  LogginViewContoller.swift
//  Swapit
//
//  Created by Dustin Yang on 8/11/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import FoldingTabBar




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
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.setup()
        appDelegate.window?.rootViewController  = appDelegate.tabBarController
        appDelegate.tabBarController.selectedIndex = 1;
        
        println("afdasfdsadfasfdsafd")
        
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overViewVC = sb.instantiateViewControllerWithIdentifier("tableMainView") as! YALFoldingTabBarController
        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(overViewVC, animated: true)

 
        
        
        
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
    

    
      
}
