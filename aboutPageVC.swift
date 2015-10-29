//
//  aboutPageVC.swift
//  Swapit
//
//  Created by Dustin Yang on 10/27/15.
//  Copyright © 2015 Dustin Yang. All rights reserved.
//

import UIKit

class aboutPageVC: UIViewController {

    let bounds = UIScreen.mainScreen().bounds
    var titleLabel : UILabel = UILabel()
    var versionLabel : UILabel = UILabel()
    var developer : UILabel = UILabel()

    var descLabel : UILabel = UILabel()
    var descLabel2 : UILabel = UILabel()

    var thanksLabel : UILabel = UILabel()
    var titleLabel2 : UILabel = UILabel()
    var name1 : UILabel = UILabel()
    var name2 : UILabel = UILabel()
    var name3 : UILabel = UILabel()
    var name4 : UILabel = UILabel()

    
    var titleLabel3 : UILabel = UILabel()
    var open1 : UILabel = UILabel()
    var open2 : UILabel = UILabel()
    var open3 : UILabel = UILabel()
    var open4 : UILabel = UILabel()
  //  var open5 : UILabel = UILabel()
   var thanksLabel2 : UILabel = UILabel()
    var copyright : UILabel = UILabel()


    
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)

    
    override func loadView() {
        // calling self.view later on will return a UIView!, but we can simply call
        // self.scrollView to adjust properties of the scroll view:
        self.view = self.scrollView
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.showsVerticalScrollIndicator = false;
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  scrollView.delegate = self
        
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)

        let nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.view.backgroundColor = UIColor.whiteColor()
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "icon_arrow_left.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 20, 20)
        btnName.addTarget(self, action: Selector("leftpressed"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftbutton:UIBarButtonItem = UIBarButtonItem()
        leftbutton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftbutton

        
        
        
        
        var offsetY = height*0.15
        self.scrollView.backgroundColor = UIColor.whiteColor()
        titleLabel.frame = CGRectMake(0, offsetY, width, height*(1/18))
        titleLabel.text = "VenDee"
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.font = UIFont (name: "Avenir-Heavy", size: 40)

        offsetY+=(titleLabel.frame.height)
        
        versionLabel.frame = CGRectMake(0, offsetY, width, height*(1/25))
        versionLabel.text = "Version 1.0.0"
        versionLabel.textAlignment = NSTextAlignment.Center;
        versionLabel.font = UIFont (name: "Avenir-Book", size: 16)
        

        offsetY+=(versionLabel.frame.height)+height*0.1
        
        descLabel.frame = CGRectMake(width*0.1, offsetY, width*0.8, height*(1/25))
        descLabel.text = "Vendee is the simplest way to sell/buy "
        descLabel.textAlignment = NSTextAlignment.Center;
        descLabel.font = UIFont (name: "Avenir-Light", size: 15)
        descLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        offsetY+=(descLabel.frame.height)
        descLabel2.frame = CGRectMake(width*0.1, offsetY, width*0.8, height*(1/25))
        descLabel2.text = "items by just swiping"
        descLabel2.textAlignment = NSTextAlignment.Center;
        descLabel2.font = UIFont (name: "Avenir-Light", size: 15)
        descLabel2.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        offsetY+=(descLabel2.frame.height)+height*0.05
        
        developer.frame = CGRectMake(0, offsetY, width, height*(1/25))
        developer.text = "Developer : Dustin Doosun Yang(srdpt3@gmail.com)"
        developer.textAlignment = NSTextAlignment.Center;
        developer.font = UIFont (name: "Avenir-Book", size: 12)
        
        
        
        offsetY+=(developer.frame.height)+height*0.08
        thanksLabel.frame = CGRectMake(0, offsetY, width, height*(1/20))
        thanksLabel.text = "Thank You"
        thanksLabel.textAlignment = NSTextAlignment.Center;
        thanksLabel.font = UIFont (name: "Avenir-Heavy", size: 35)

        offsetY+=(thanksLabel.frame.height)+height*0.02
        name2.frame = CGRectMake(0, offsetY, width, height*(1/20))
        name2.text = "SE Lee"
        name2.textAlignment = NSTextAlignment.Center;
        name2.font = UIFont (name: "Avenir-Book", size: 15)
       
        offsetY+=(name2.frame.height)+height*0.02
        name3.frame = CGRectMake(0, offsetY, width, height*(1/20))
        name3.text = "John Bergman for feeding me every Sunday :)"
        name3.textAlignment = NSTextAlignment.Center;
        name3.font = UIFont (name: "Avenir-Book", size: 15)
        
        offsetY+=(name3.frame.height)+height*0.02
        name4.frame = CGRectMake(0, offsetY, width, height*(1/20))
        name4.text = "James montessino for naming this App"
        name4.textAlignment = NSTextAlignment.Center;
        name4.font = UIFont (name: "Avenir-Book", size: 15)
        
        
        offsetY+=(name4.frame.height)+height*0.03
        thanksLabel2.frame = CGRectMake(0, offsetY, width, height*(1/20))
        thanksLabel2.text = "I would like to thank my family and friends"
        thanksLabel2.textAlignment = NSTextAlignment.Center;
        thanksLabel2.font = UIFont (name: "Avenir-Light", size: 18)
        thanksLabel2.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        offsetY+=(thanksLabel2.frame.height)+height*0.03
        titleLabel3.frame = CGRectMake(0, offsetY, width, height*(1/20))
        titleLabel3.text = "OpenSource"
        titleLabel3.textAlignment = NSTextAlignment.Center;
        titleLabel3.font = UIFont (name: "Avenir-Heavy", size: 35)
        
        offsetY+=(titleLabel3.frame.height)+height*0.03
        open1.frame = CGRectMake(0, offsetY, width, height*(1/20))
        open1.text = "Facebook Shimmering"
        open1.textAlignment = NSTextAlignment.Center;
         open1.textColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        open1.font = UIFont (name: "Avenir-Book", size: 16)
        
        offsetY+=(open1.frame.height)+height*0.03
        open2.frame = CGRectMake(0, offsetY, width, height*(1/20))
        open2.text = "PulsingHaloLayer"
        open2.textAlignment = NSTextAlignment.Center;
        open2.textColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        open2.font = UIFont (name: "Avenir-Book", size: 15)
        
        offsetY+=(open2.frame.height)+height*0.03
        open3.frame = CGRectMake(0, offsetY, width, height*(1/20))
        open3.text = "JSQMessage"
        open3.textAlignment = NSTextAlignment.Center;
        open3.textColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        open3.font = UIFont (name: "Avenir-Book", size: 15)
        
        
        offsetY+=(open3.frame.height)+height*0.03
        open4.frame = CGRectMake(0, offsetY, width, height*(1/20))
        open4.text = "https://github.com/Yalantis/FoldingTabBar.iOS"
        open4.textAlignment = NSTextAlignment.Center;
        open4.textColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        open4.font = UIFont (name: "Avenir-Book", size: 15)

        
        offsetY+=(thanksLabel2.frame.height)+height*0.04
        copyright.frame = CGRectMake(0, offsetY, width, height*(1/20))
        copyright.text = "@2015 Dustin Yang - All rights reserved"
        copyright.textAlignment = NSTextAlignment.Center;
        copyright.font = UIFont (name: "Avenir-Light", size: 15)
        copyright.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(versionLabel)
        self.scrollView.addSubview(descLabel)
        self.scrollView.addSubview(descLabel2)
        self.scrollView.addSubview(developer)

        self.scrollView.addSubview(thanksLabel)
        self.scrollView.addSubview(name2)
        self.scrollView.addSubview(name3)
        self.scrollView.addSubview(name4)
        self.scrollView.addSubview(titleLabel3)
        self.scrollView.addSubview(open1)
        self.scrollView.addSubview(open2)
        self.scrollView.addSubview(open3)
        self.scrollView.addSubview(open4)
        self.scrollView.addSubview(thanksLabel2)
        self.scrollView.addSubview(copyright)

        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, self.scrollView.frame.height*1.5)

       // view.addSubview(scrollView)


        
        
        /*

        
        
        var titleLabel3 : UILabel = UILabel()
        var open1 : UILabel = UILabel()
        var open2 : UILabel = UILabel()
        var open3 : UILabel = UILabel()
        var copyright : UILabel = UILabel()

        */
        

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    
    func leftpressed()
    {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
