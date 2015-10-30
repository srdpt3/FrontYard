//
//  ViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

let waterfallViewCellIdentify = "waterfallViewCellIdentify"
var block_trigger : Bool = false
var update_status:Bool = false

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let transition = NTTransition()
        transition.presenting = operation == .Pop
        return  transition
    }
}


class NTWaterfallViewController:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{
    //    class var sharedInstance: NSInteger = 0 Are u kidding me?
    @IBAction func refreshButton(sender: AnyObject) {
        
        
        getfavoritelist()
        
    }
    var imageNameList : Array <NSString> = []
    let delegateHolder = NavigationControllerDelegate()
    var otherlocation =  [PFGeoPoint]()
    var otherImageFiles = [PFFile]()
    var otherObjID = [String]()
    var otherUsers = [String]()
    var pricelabel = [Int]()
    var currency = [String]()
    var itemTitle = [String]()
    var itemDesc = [String]()
    var swipedImages: [UIImage] = []
    var noitemLabel: UILabel!
    var FBshimmering : FBShimmeringView!
    override func viewDidAppear(animated: Bool) {
  
    }
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController!.delegate = delegateHolder
        self.navigationController!.delegate = nil
        
        self.view.backgroundColor = UIColor.whiteColor()
        let nav = self.navigationController?.navigationBar
        self.navigationItem.title = "My Favorites"
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        nav?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

       
        let collection :UICollectionView = collectionView!;
        // collection.frame = screenBounds
        
        collection.frame = CGRectMake(10, 0, screenWidth-19, screenHeight)
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
      
        collection.showsHorizontalScrollIndicator = false;
        collection.showsVerticalScrollIndicator = false;
        collection.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)

        noitemLabel = UILabel(frame: CGRectMake(0 , self.view.frame.size.height*0.8, self.view.frame.size.width, self.view.frame.size.height*0.1))
        noitemLabel.textAlignment = NSTextAlignment.Center;
        noitemLabel.text = "No Items..."

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        
        let image:UIImage! = swipedImages[indexPath.row]
       // let imageHeight = image.size.height*gridWidth/image.size.width
        let imageHeight = (image.size.height+30)*gridWidth/image.size.width

        return CGSizeMake(gridWidth, imageHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell: NTWaterfallViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(waterfallViewCellIdentify, forIndexPath: indexPath) as! NTWaterfallViewCell
        
        collectionCell.imageFile =  self.swipedImages[indexPath.row]
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
        return swipedImages.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        self.navigationController?.navigationBarHidden = false

        self.navigationController?.hidesBarsOnSwipe = false

        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.imageFile = swipedImages
        pageViewController.pricelabel = pricelabel
        pageViewController.currency = currency
        pageViewController.itemTitle = itemTitle
        pageViewController.itemDesc = itemDesc
        pageViewController.otherusers = otherUsers
        pageViewController.otherObjID = otherObjID
         pageViewController.otherlocation = otherlocation
          collectionView.setToIndexPath(indexPath)
        
        
        let transition : CATransition = CATransition()
        transition.duration = 0.8
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromLeft;

        navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
       navigationController!.pushViewController(pageViewController, animated: true)
      //  navigationController!.presentViewController(pageViewController, animated: true,completion: nil)

        
        
    }
    override func viewWillDisappear(animated: Bool) {

        
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
        
       if(block_trigger || update_status )
       {
           print("trigger")
            getfavoritelist()
        
       }
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    
    
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition = .CenteredHorizontally
      //  .CenteredHorizontally & .CenteredVertically
        //  let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as String)
        let image:UIImage! =  swipedImages[pageIndex]
        
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
    
    func getfavoritelist()
    {
        
        CozyLoadingActivity.Settings.CLASuccessText = ""
        CozyLoadingActivity.Settings.CLASuccessIcon = ""
        CozyLoadingActivity.Settings.CLATextColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        CozyLoadingActivity.Settings.CLAActivityColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
        CozyLoadingActivity.show("Loading...", sender: self, disableUI: false)
        
        swipedImages.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        itemTitle.removeAll(keepCapacity: false)
        itemDesc.removeAll(keepCapacity: false)
        pricelabel.removeAll(keepCapacity: false)
        currency.removeAll(keepCapacity: false)
        otherlocation.removeAll(keepCapacity: false)

        let query:PFQuery = PFQuery(className: "imageUpload")
        query.addDescendingOrder("updatedAt")
        query.whereKey("interesting", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("Block",notEqualTo: PFUser.currentUser()!.username!)
        query.whereKey("passed", notEqualTo: PFUser.currentUser()!.username!)
        query.whereKey("chat", notEqualTo: PFUser.currentUser()!.username!)
        

        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                let objects = results as! [PFObject]

                if (objects.count == 0){
                    let alert = UIAlertController(title: "No Favorite Items...", message: "Swipe Something To The Right! ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.collectionView!.reloadData()

                     CozyLoadingActivity.hide(success: true, animated: true)
                    
                    self.FBshimmering = FBShimmeringView(frame: CGRectMake(0 , self.view.frame.size.height*0.8, self.view.frame.size.width, self.view.frame.size.height*0.1))
                    self.view.addSubview(self.FBshimmering)
                    
                    
                    
                    
                    self.FBshimmering.contentView = self.noitemLabel
                    self.FBshimmering.shimmering = true
                    self.FBshimmering.shimmeringBeginFadeDuration = 0.1;
                    self.FBshimmering.shimmeringOpacity = 0.1;
                    
                    self.view.addSubview(self.noitemLabel)
                    
                    
                    
                    
                    
                }
                for obj in objects{
                    let itemTitle = obj["itemname"]! as! String
                    let itemDesc = obj["description"]! as! String
                    let pricelabel = obj["price"]!
                    let currency = obj["Currency"]! as! String
                    let otheruser = obj["user"] as! PFObject
                    self.otherUsers.append(otheruser.objectId!)
                    let thumbNail = obj["image"] as! PFFile
          
                    let query2 = PFQuery(className: "_User")
                    query2.whereKey("objectId", equalTo: otheruser.objectId!)
                    
                    query2.findObjectsInBackgroundWithBlock({ (result2, error2) -> Void in
                        
                        if error2 == nil
                        {
                            for obj in result2! {
                                let location: PFGeoPoint  = obj["location"] as! PFGeoPoint
                                   self.otherlocation.append(location)

                                }
                            }
                    })
                    thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) -> Void in
                        
                        if error2 == nil
                        {
                            let image = UIImage(data:imageData!)
                            //image object implementation
                            self.swipedImages.append(image!)
                            self.itemTitle.append(itemTitle)
                            self.itemDesc.append(itemDesc)
                            self.pricelabel.append(Int(pricelabel as! NSNumber))
                            self.currency.append(currency)
                            // self.otherUsers.append(otheruser)
                            
                            let objId = obj.objectId! as String
                            self.otherObjID.append(objId)
                            if(objects.count == self.swipedImages.count ){
                                let collection :UICollectionView = self.collectionView!;
                                collection.reloadData()
                                block_trigger = false
                                update_status = false
                                self.noitemLabel.removeFromSuperview()
                                CozyLoadingActivity.hide(success: true, animated: true)

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
    
    
}
