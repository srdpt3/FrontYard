



//
//  AppDelegate.swift
//  Swapit
//
//  Created by Dustin Yang on 8/10/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import FoldingTabBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: YALFoldingTabBarController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("3YIT5b7gX4993SswqN3qAVq0mk8sOrXgn8o7cpE1",clientKey:"FuVje4F5el2mWCwFtMMClnxdbwAUsNeK6y7tyDid")
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        
        let notificationTypes:UIUserNotificationType = UIUserNotificationType.Alert.union(UIUserNotificationType.Badge ).union(UIUserNotificationType.Sound)
        let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        self.tabBarController?.tabBar.hidden = true
        
        return true
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
    }

    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (success, error) -> Void in
            if(error == nil)
            {
                print(" set device successfully//")
            }
        }
        
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
       // PFPush.handlePush(userInfo)
        
        AudioServicesPlayAlertSound(1110)
        NSNotificationCenter.defaultCenter().postNotificationName("ds", object: userInfo)

        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
        
      

        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
    }

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "doosun._______________" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("_______________", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    
    func setup()
    {
        
        tabBarController = YALFoldingTabBarController()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signUPVC = sb.instantiateViewControllerWithIdentifier("ChatOverViewNav") as! nav
        
        
        signUPVC.navigationController?.navigationBar.hidden = false
        signUPVC.navigationItem.hidesBackButton = false
        
  
      //  let = sb.instantiateViewControllerWithIdentifier("photoViewNav") as! photoViewNav
        let SwapItMain = sb.instantiateViewControllerWithIdentifier("SwapItMainViewController") as! SwapItMainNav
        let settingPage = sb.instantiateViewControllerWithIdentifier("SettingVCNav") as! SettingVCNav

        let favoriteView = sb.instantiateViewControllerWithIdentifier("WaterfallViewController") as! NTNavigationController
        
    //    var item1 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"), leftItemImage: nil, rightItemImage: nil)
        let item1 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "star"), leftItemImage: nil, rightItemImage: nil)

       // var item2 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "profile_icon"), leftItemImage: UIImage(named: "edit_icon"), rightItemImage: nil)
        let item2 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "profile_icon"), leftItemImage: nil, rightItemImage: nil)
        let item3 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "chats_icon"), leftItemImage: UIImage(named: "search_icon"), rightItemImage: UIImage(named: "new_chat_icon"))
    //    var item4 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "settings_icon"), leftItemImage: nil, rightItemImage: nil)
        let item4 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "gear"), leftItemImage: nil, rightItemImage: nil)

        
             
    
        
        tabBarController.leftBarItems = [item1, item2];
        tabBarController.rightBarItems = [item3, item4];
        
       // tabBarController.centerButtonImage = UIImage(named:"plus_icon")
        tabBarController.centerButtonImage = UIImage(named:"bar.gif")
        
        
        tabBarController.viewControllers = [favoriteView,SwapItMain,signUPVC,settingPage]
        
        //   tabBarController.tabBarView.counzz
        tabBarController.selectedIndex = 1;
        
        //customize tabBarView
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
       tabBarController.tabBarView.backgroundColor = backgroundColor
        tabBarController.tabBarView.tabBarColor  =  UIColor(red: 132/255.0, green: 216/225.0, blue: 192/255.0, alpha: 1)
        
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
        tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
        tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
        print("TAbar Setup called")
        tabBarController.navigationController?.navigationBar.hidden = false
        
        //  }

        
        
    }
    


}

