//
//  ViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit


let ViewCellIdentify3 = "ViewCellIdentify3"


extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

class myItemView:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{
    //    class var sharedInstance: NSInteger = 0 Are u kidding me?
    @IBAction func refreshButton(sender: AnyObject) {
        getThumnails()
        
    }
    let bounds = UIScreen.mainScreen().bounds
    var imageViewContent : UIImageView = UIImageView()
    var profileimageView : UIImageView = UIImageView()
    var namelabel: UILabel  = UILabel()
    var locationLabel: UILabel  = UILabel()
    var numItemsLabel: UILabel  = UILabel()
    
    
    
    var imageNameList : Array <NSString> = []
    let delegateHolder = NavigationControllerDelegate()
    var otherImageFiles = [PFFile]()
    var otherObjID = [String]()
    var pricelabel = [Int]()
    var currency = [String]()
    var itemTitle = [String]()
    var itemDesc = [String]()
    var otherImages: [UIImage] = []
    
    var profileimage: UIImage!
    
    
    
    var otherUser : PFUser!
    var userLocation :String!
 
    
    var currentUser = PFUser.currentUser()!
    
    override func viewDidAppear(animated: Bool) {
        //self.obj.collectionView?.reloadData()
        //  self.collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        
        
        
        self.navigationController!.delegate = nil
        
        self.view.backgroundColor = UIColor.whiteColor()
        let nav = self.navigationController?.navigationBar
        
        
        self.navigationItem.title = "My Item List"
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "icon_arrow_left.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 20, 20)
        btnName.addTarget(self, action: Selector("leftpressed"), forControlEvents: .TouchUpInside)
        //SetLeft Bar Button item
        let leftbutton:UIBarButtonItem = UIBarButtonItem()
        leftbutton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftbutton
        
        
        
        let navBarHeight = nav?.frame.height
        imageViewContent.frame = CGRectMake(0, navBarHeight!, width, height*0.1)
        profileimageView.frame = CGRectMake(width*0.05, 0, self.imageViewContent.frame.height ,self.imageViewContent.frame.height)
        //  namelabel.frame = CGRectMake(width*0.2, 0, 100 ,40)
        
        namelabel.frame = CGRectMake(width*0.3, self.imageViewContent.frame.height*0.1, width*0.4 ,self.imageViewContent.frame.height*0.4)
        // locationLabel.frame = CGRectMake(width*0.05, 0, self.imageViewContent.frame.height ,self.imageViewContent.frame.height)
        numItemsLabel.frame = CGRectMake(width*0.3, self.imageViewContent.frame.height*0.45, width*0.7 ,self.imageViewContent.frame.height*0.5)
        
        //imageView
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = CGRectMake(0, 0, width, height*0.1)
        
        //let user = PFUser.currentUser()!
        
        if let userImageFile = currentUser["profileImage"] as? PFFile {
            
            userImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                if error == nil{
                    
                    self.profileimageView.image = UIImage(data:data!)
                    // self.profileimageView.center  = CGPointMake(self.imageViewContent.frame.width/2, (self.imageViewContent.frame.height)/2)
                    self.profileimageView.layer.cornerRadius = self.profileimageView.frame.size.width/2
                    self.profileimageView.clipsToBounds = true
                    
                    self.imageViewContent.image = UIImage(data:data!)
                    
                }
            }
        }
        
        
        namelabel.textColor = UIColor.whiteColor()
        numItemsLabel.textColor = UIColor.whiteColor()
        
        numItemsLabel.font = numItemsLabel.font.fontWithSize(12)
        namelabel.font = namelabel.font.fontWithSize(13)

        namelabel.text = currentUser.username!
 
        

        
        let collection :UICollectionView = collectionView!;
        // collection.frame = screenBounds
        
        collection.frame = CGRectMake(10, imageViewContent.frame.height, screenWidth-19, screenHeight-imageViewContent.frame.height)
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(myItemViewCell.self, forCellWithReuseIdentifier: ViewCellIdentify3)
        // collection.reloadData()
        getThumnails()
        
        collection.showsHorizontalScrollIndicator = false;
        collection.showsVerticalScrollIndicator = false;
        collection.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
         self.imageViewContent.addSubview(effectView)
        self.imageViewContent.addSubview(profileimageView)
        self.imageViewContent.addSubview(namelabel)
        self.imageViewContent.addSubview(numItemsLabel)
        
        // self.view.addSubview(imageViewContent)
        
        
        self.navigationController?.navigationBar.addSubview(imageViewContent)
        
    }
    
    // Determine other user's location
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        
        let image:UIImage! = otherImages[indexPath.row]
        // let imageHeight = image.size.height*gridWidth/image.size.width
        let imageHeight = (image.size.height+30)*gridWidth/image.size.width
        
        return CGSizeMake(gridWidth, imageHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell: myItemViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewCellIdentify3, forIndexPath: indexPath) as! myItemViewCell
        
        
        if (indexPath.row > 6){
            //  self.navigationController?.navigationBarHidden = true
            self.navigationController?.navigationBar.fadeOut()
            
            
            
        }
        else {
            // self.navigationController?.navigationBarHidden = false
            self.navigationController?.navigationBar.fadeIn()
            
        }
        collectionCell.imageFile =  self.otherImages[indexPath.row]
        collectionCell.imageLabel.text = " \(self.itemTitle[indexPath.row])"
        var currency_exchange : Int = 0
        var price_display :  String  = ""
        if (self.currency[indexPath.row] == "￦")
        {   if (Double(self.pricelabel[indexPath.row]) >= 10  )
        {
            currency_exchange = Int(Double(self.pricelabel[indexPath.row]) * 0.1)
            price_display = "\(currency_exchange)만원"
        }
        else
        {
            currency_exchange = Int(Double(self.pricelabel[indexPath.row]) * 1000)
            price_display = "\(currency_exchange)"
            
            }
        }
        else
        {
            price_display = "\(self.currency[indexPath.row])\(self.pricelabel[indexPath.row])"
        }
        
        
        collectionCell.imageLabel2.text = "\(price_display)"

        collectionCell.setNeedsLayout()
        return collectionCell;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return otherImages.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let uiAlert = UIAlertController(title: "Delete", message: "Are you sure to remove your item?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { action in
            
            CozyLoadingActivity.Settings.CLASuccessText = "Done"
            CozyLoadingActivity.show("Deleting...", sender: self, disableUI: false)
            
            
            
            // var query = PFQuery(className: "imageUpload")
            let query = PFQuery(className:"Post")
            query.whereKey("obj_ptr", equalTo: PFObject(withoutDataWithClassName:"imageUpload", objectId:self.otherObjID[indexPath.row]))
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error == nil
                {
                    let objects = results as? [PFObject]
                    
                    for obj in objects!
                    {
                        obj.deleteInBackgroundWithBlock { (success, error
                            ) -> Void in
                            if (success) {
                                // The object has been saved.
                                CozyLoadingActivity.hide(success: true, animated: true)
                            
                                
                            } else {
                                // There was a problem, check error.description
 
                                
                            }
                            
                        }

                    }
                    
                    
                }
                else
                {
                    print(error)
                }
            })
            
            let object: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: self.otherObjID[indexPath.row])
            object.deleteInBackgroundWithBlock { (success, error
                ) -> Void in
                if (success) {
                    print ("sucess")
                    let collection :UICollectionView = self.collectionView!;
                    
                    
                    collection.reloadData()
                    self.getThumnails()
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    // There was a problem, check error.description
                    print(error)
                }
                
            }
            
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            print("Click of cancel button")
        }))

        
        /*
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.imageFile = swipedImages
        pageViewController.pricelabel = pricelabel
        pageViewController.itemTitle = itemTitle
        pageViewController.itemDesc = itemDesc
        pageViewController.otherusers = otherUsers
        pageViewController.otherObjID = otherObjID
        pageViewController.otherlocation = otherlocation
        
        
        
        
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
        
        */
        
        
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.navigationBarHidden ?
            CGSizeMake(screenWidth, screenHeight+20) : CGSizeMake(screenWidth, screenHeight-navigationHeaderAndStatusbarHeight)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }
    override func viewWillAppear(animated: Bool) {
        // self.collectionView!.reloadData()
        
    }
    
    
    
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition = .CenteredHorizontally
        //  .CenteredHorizontally & .CenteredVertically
        //  let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as String)
        let image:UIImage! =  otherImages[pageIndex]
        
        let imageHeight = image.size.height*gridWidth/image.size.width
        if imageHeight > 400 {//whatever you like, it's the max value for height of image
            position = .Top
        }
        let currentIndexPath = NSIndexPath(forRow: pageIndex, inSection: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        if pageIndex<2{
            collectionView.setContentOffset(CGPointZero, animated: false)
        }else{
            collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: position, animated: false)
        }
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getThumnails()
    {
        
        
        otherImages.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        itemTitle.removeAll(keepCapacity: false)
        itemDesc.removeAll(keepCapacity: false)
        pricelabel.removeAll(keepCapacity: false)
        currency.removeAll(keepCapacity: false)

        let query:PFQuery = PFQuery(className: "imageUpload")
        query.addDescendingOrder("updatedAt")
        query.whereKey("user", equalTo: currentUser)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                let objects = results as! [PFObject]
                
                if( objects.count == 0)
                {
                    self.numItemsLabel.text = "No Item Found To Delete"
                }
                else
                {
                    self.numItemsLabel.text = "Select The Item To Delete";
                }
                
                for obj in objects{
                    let itemTitle = obj["itemname"]! as! String
                    let itemDesc = obj["description"]! as! String
                    let pricelabel = obj["price"]!
                    let currency = obj["Currency"]! as! String
                    //      let otheruser = obj["user"] as! PFObject
                    //    self.otherUsers.append(otheruser["user"])
                    let thumbNail = obj["image"] as! PFFile
    
                    thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) -> Void in
                        
                        if error2 == nil
                        {
                            let image = UIImage(data:imageData!)
                            //image object implementation
                            self.otherImages.append(image!)
                            self.itemTitle.append(itemTitle)
                            self.itemDesc.append(itemDesc)
                            self.pricelabel.append(Int(pricelabel as! NSNumber))
                            self.currency.append(currency)
                            // self.otherUsers.append(otheruser)
                            
                            let objId = obj.objectId! as String
                            self.otherObjID.append(objId)
                            if(objects.count == self.otherImages.count ){
                                let collection :UICollectionView = self.collectionView!;
                                
                                // self.numItemsLabel.text = "Items: \(self.otherImages.count) @\(self.userLocation)"
                                
                                collection.reloadData()
                            }
                            
                            
                        }
                        
                        
                        
                    })
                    
                }
                
                
            }
            else
            {
                print("erorr in getfavoritelist ")
            }
            
            
        }
    }
    override func viewWillDisappear(animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = false
        
        imageViewContent.removeFromSuperview()
    }
    
    func leftpressed()
    {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
