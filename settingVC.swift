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
    var itemManage :UIButton = UIButton()
    var contactDeveloper :UIButton = UIButton()
    var shareApp :UIButton = UIButton()
    var rateApp :UIButton = UIButton()
    

    @IBAction func saveButtonpressed(sender: AnyObject) {
        price.text = "    Min: $\(Int(round(rangeSlider1.lowerValue))) - Max: $\(Int(round(rangeSlider1.upperValue)))"

        minPrice = Int(round(rangeSlider1.lowerValue))
        maxPrice = Int(round(rangeSlider1.upperValue))

       /// print(minPrice)
       /// /print(maxPrice)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overViewVC = sb.instantiateViewControllerWithIdentifier("loaddataViewController") as! loaddataViewController
        overViewVC.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.pushViewController(overViewVC, animated: true)

        
        
    }
    //  UIBarButtonItem(title: "CUSTOM", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.hidden = true
        
        let nav = self.navigationController?.navigationBar
        self.navigationItem.title = "Setting"
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        
        
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "icon_arrow_left.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 20, 20)
        btnName.addTarget(self, action: Selector("leftpressed:"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftbutton:UIBarButtonItem = UIBarButtonItem()
        leftbutton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftbutton

        
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
        var rangeViewHeightOffset = height*(1/3)+navBarHeight!
        let margin: CGFloat = 10.0
        
        rangeSlider1.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 50, width: view.bounds.width - 2.0 * margin, height: 31.0)
        rangeSlider1.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        // minPrice.text = "\(Int(round(rangeSlider1.lowerValue)))"
        // maxPrice.text = "\(Int(round(rangeSlider1.upperValue)))"
        SearchLabel.frame = CGRectMake(width*0.01, rangeViewHeightOffset, width, height*(1/24))
        
        SearchLabel.text = "Search Price Range"
        SearchLabel.textAlignment = NSTextAlignment.Natural;
        SearchLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        SearchLabel.font = SearchLabel.font.fontWithSize(15)
        

        rangeViewHeightOffset+=(SearchLabel.frame.height)
        price.frame = CGRectMake(width/4, rangeViewHeightOffset, width, height*(1/12))
        
        
        price.text = "    Min: $\(Int(round(rangeSlider1.lowerValue))) - Max: $\(Int(round(rangeSlider1.upperValue)))"
        price.textColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        price.font = price.font.fontWithSize(16)
        RangeView.frame = CGRectMake(0, rangeViewHeightOffset , width, height*(1/6))
        RangeView.backgroundColor = UIColor.whiteColor()
        RangeView.addSubview(rangeSlider1)
        
        
        //Contact Developer
        var buttonOffset = height-height*(1/3)
        
        
        
        itemManage.frame = CGRectMake(0, buttonOffset, width, height*(1/12))
        itemManage.setTitle(" Manage Items", forState: UIControlState.Normal)
        itemManage.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        itemManage.setTitleColor(UIColor(red: 116/255, green: 116/255, blue:116/255, alpha: 1.0), forState: UIControlState.Normal)
        itemManage.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        itemManage.addTarget(self, action: "ManageItems:", forControlEvents: UIControlEvents.TouchUpInside)
        itemManage.clipsToBounds = true
        itemManage.layer.cornerRadius = 0.0
        itemManage.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        itemManage.layer.borderWidth = 0.5;

        
        buttonOffset+=(itemManage.frame.height)
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
        buttonOffset+=(contactDeveloper.frame.height)
        shareApp.frame = CGRectMake(0, height-height*(1/6), width, height*(1/12))
        shareApp.setTitle(" Share this App", forState: UIControlState.Normal)
        shareApp.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        shareApp.setTitleColor(UIColor(red: 116/255, green: 116/255, blue:116/255, alpha: 1.0), forState: UIControlState.Normal)
        shareApp.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        shareApp.addTarget(self, action: "sharethisapp:", forControlEvents: UIControlEvents.TouchUpInside)
        
        shareApp.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        shareApp.layer.borderWidth = 0.25;
        
        buttonOffset+=(shareApp.frame.height)
        
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
        self.view.addSubview(itemManage)

        self.view.addSubview(contactDeveloper)
        self.view.addSubview(shareApp)
        self.view.addSubview(rateApp)
        
        
        
        
    }
    
    func leftpressed(sender:UIBarButtonItem){
        

        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = false
        appDelegate.tabBarController?.selectedIndex = 1
        
        
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
    
    
    @IBAction func ManageItems(sender:UIButton!)
    {
        let SettingactionSheet = UIAlertController(title: "Setting Menu", message: "Select what you want to do", preferredStyle: UIAlertControllerStyle.ActionSheet)
        

        
        SettingactionSheet.addAction(UIAlertAction(title: "List Item", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let photoUploadVC = sb.instantiateViewControllerWithIdentifier("photoViewController") as! photoUploadPageVC
            //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(photoUploadVC, animated: true)
            
            
        }))
        
        SettingactionSheet.addAction(UIAlertAction(title: "Delete Item", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let myItemVC = sb.instantiateViewControllerWithIdentifier("myItemView") as! myItemView
            //  signUPVC.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(myItemVC, animated: true)
            
            
            
        }))
        
        SettingactionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel  , handler: nil))
        self.presentViewController(SettingactionSheet, animated: true, completion: nil)

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
