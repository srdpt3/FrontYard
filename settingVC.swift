//
//  settingVC.swift
//  Swapit
//
//  Created by Dustin Yang on 9/1/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//
import UIKit
import Social

class settingVC: UIViewController {
    
    let bounds = UIScreen.mainScreen().bounds
    
    var imageViewContent : UIImageView = UIImageView()
    var profileimageView : UIImageView = UIImageView()
    var SearchLabel : UILabel = UILabel()
    var RangeView : UIView = UIView()
    var price: UILabel! = UILabel()
    let rangeSlider1 = RangeSlider(frame: CGRectZero)
    var contactDeveloper :UIButton = UIButton()
    var shareApp :UIButton = UIButton()
    var rateApp :UIButton = UIButton()
    
    
    //  UIBarButtonItem(title: "CUSTOM", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.hidden = true
        let nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        let logoButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
        logoButton.setImage(UIImage(named: "main.gif"), forState: UIControlState.Normal)
        logoButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
        self.navigationItem.titleView = logoButton
        
        
        let myBackButton:UIButton = UIButton()
        myBackButton.addTarget(self, action: "SwipeScreen:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.imageView!.image = UIImage(named: "chats_icon")
       // myBackButton.setTitle("<<", forState: UIControlState.Normal)
       // myBackButton.setTitleColor(UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0), forState: UIControlState.Normal)
      //  myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        let navBarHeight = nav?.frame.height
        imageViewContent.frame = CGRectMake(0, navBarHeight!, width, height*(1/3))
        profileimageView.frame = CGRectMake(width/2, imageViewContent.frame.height/2, 100,100)
        
        //imageView
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = CGRectMake(0, 0, width, height*(1/3))
        
        
        //get profile image
        
        let user = PFUser.currentUser()!

        
        //  let profileImageFile : PFFile! = user2["profileImage"] as! PFFile
        
        if let userImageFile = user["profileImage"] as? PFFile {
            
            userImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                if error == nil{
                    
                    self.profileimageView.image = UIImage(data:data!)
                    self.profileimageView.center  = CGPointMake(self.imageViewContent.frame.width/2, (self.imageViewContent.frame.height+navBarHeight!)/2)
                    self.profileimageView.layer.cornerRadius = self.profileimageView.frame.size.width/2
                    self.profileimageView.clipsToBounds = true
                    
                    self.imageViewContent.image = UIImage(data:data!)
                    
                }
            }
        }
        
        
        
        //Price Search Range
        let rangeViewHeightOffset = height*(1/3)+navBarHeight!
        let margin: CGFloat = 10.0
        
        rangeSlider1.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 50, width: view.bounds.width - 2.0 * margin, height: 31.0)
        rangeSlider1.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        // minPrice.text = "\(Int(round(rangeSlider1.lowerValue)))"
        // maxPrice.text = "\(Int(round(rangeSlider1.upperValue)))"
        SearchLabel.frame = CGRectMake(0, rangeViewHeightOffset, width, height*(1/12))
        
        SearchLabel.text = "SEARCH PRICE RANGE"
        SearchLabel.textAlignment = NSTextAlignment.Natural;
        SearchLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        SearchLabel.font = SearchLabel.font.fontWithSize(15)
        

        
        price.frame = CGRectMake(width/4, rangeViewHeightOffset+height*(1/10), width, height*(1/12))
        
        
        price.text = "    Min: $\(Int(round(rangeSlider1.lowerValue))) - Max: $\(Int(round(rangeSlider1.upperValue)))"
        price.textColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        price.font = price.font.fontWithSize(16)
        RangeView.frame = CGRectMake(0, rangeViewHeightOffset+height*(1/12) , width, height*(1/6))
        RangeView.backgroundColor = UIColor.whiteColor()
        RangeView.addSubview(rangeSlider1)
        
        
        //Contact Developer
        let buttonOffset = height-height*(1/4)
        contactDeveloper.frame = CGRectMake(0, buttonOffset, width, height*(1/12))
        contactDeveloper.setTitle(" Contact Developer", forState: UIControlState.Normal)
        
        contactDeveloper.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        contactDeveloper.setTitleColor(UIColor(red: 116/255, green: 116/255, blue:116/255, alpha: 1.0), forState: UIControlState.Normal)
        contactDeveloper.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        contactDeveloper.addTarget(self, action: "contactDeveloper:", forControlEvents: UIControlEvents.TouchUpInside)
        contactDeveloper.clipsToBounds = true
        contactDeveloper.layer.cornerRadius = 0.0
        contactDeveloper.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        contactDeveloper.layer.borderWidth = 0.5;
        
        //Share App
        shareApp.frame = CGRectMake(0, height-height*(1/6), width, height*(1/12))
        shareApp.setTitle(" Share this App", forState: UIControlState.Normal)
        shareApp.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        shareApp.setTitleColor(UIColor(red: 116/255, green: 116/255, blue:116/255, alpha: 1.0), forState: UIControlState.Normal)
        shareApp.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        shareApp.addTarget(self, action: "sharethisapp:", forControlEvents: UIControlEvents.TouchUpInside)
        
        shareApp.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        shareApp.layer.borderWidth = 0.25;
        
        //Rate App
        rateApp.frame = CGRectMake(0, height-height*(1/12), width, height*(1/12))
        rateApp.setTitle(" Rate this App", forState: UIControlState.Normal)
        rateApp.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        rateApp.setTitleColor(UIColor(red: 116/255, green: 116/255, blue:116/255, alpha: 1.0), forState: UIControlState.Normal)
        rateApp.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        rateApp.addTarget(self, action: "ratethisapp:", forControlEvents: UIControlEvents.TouchUpInside)
        rateApp.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        rateApp.layer.borderColor = UIColor.lightGrayColor().CGColor
        rateApp.layer.borderWidth = 0.25;
        
        
        self.imageViewContent.addSubview(effectView)
        self.imageViewContent.addSubview(profileimageView)
        self.view.addSubview(imageViewContent)
        self.view.addSubview(SearchLabel)
        self.view.addSubview(RangeView)
        self.view.addSubview(price)
        self.view.addSubview(contactDeveloper)
        self.view.addSubview(shareApp)
        self.view.addSubview(rateApp)
        
        
        
        
    }
    
    func SwipeScreen(sender:UIBarButtonItem){
        
        //self.tabBarController?.selectedIndex = 2
       // self.tabBarController?.tabBar.hidden = false
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = false
        appDelegate.tabBarController?.selectedIndex = 2
        
        
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        // println("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        price.text = "    Min: $\(Int(round(rangeSlider1.lowerValue))) - Max: $\(Int(round(rangeSlider1.upperValue)))"
        
    }
    
    @IBAction func contactDeveloper(sender:UIButton!)
    {
        let email = "srdpt3@gmail.com"
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    
    
    
    @IBAction func sharethisapp(sender:UIButton!)
    {
        
        
        //sharetoface.textView.enabled = false
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            // if user has logged in, get an instance for Composer
            let fb = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            // Set the text for facebook share.
            fb.setInitialText("Swapit")
            
            // add an image if needed.
            fb.addImage(UIImage(named: "main.gif"))
            
            // display composer view controller
            self.presentViewController(fb, animated: true, completion:nil)
        } else {
            // Display alert if Facebook not configured.
 
            let av = UIAlertController(title: "Message", message: "Facebook not configured on your device. Go to Settings -> Facebook and log in to share", preferredStyle: UIAlertControllerStyle.Alert)
            av.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(av, animated: true, completion: nil)
            
          //  av.show()
        }
    }
    
    @IBAction func ratethisapp(sender:UIButton!)
    {
        print("reportButtonPressed  tapped")
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
