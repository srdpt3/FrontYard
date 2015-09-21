//
//  ViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

let waterfallViewCellIdentify = "waterfallViewCellIdentify"

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let transition = NTTransition()
        transition.presenting = operation == .Pop
        return  transition
    }
}

class NTWaterfallViewController:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{
//    class var sharedInstance: NSInteger = 0 Are u kidding me?
    var imageNameList : Array <NSString> = []
    let delegateHolder = NavigationControllerDelegate()
    
    var otherImageFiles = [PFFile]()
    var otherObjID = [String]()
    var otherUsers = [String]()
    var pricelabel = [String]()
    var itemTitle = [String]()
    var itemDesc = [String]()
    var swipedImages: [UIImage] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
       // self.navigationController!.delegate = delegateHolder
        self.navigationController!.delegate = nil

        self.view.backgroundColor = UIColor.whiteColor()
        var nav = self.navigationController?.navigationBar

        self.navigationItem.title = "asdfasdfasd"
        if let font = UIFont(name: "Lato-Light.ttf", size: 34) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        

   
    nav?.barStyle = UIBarStyle.Default
      //  nav!.backgroundColor = UIColor(red: 67.0/255.0, green: 179.0/255.0, blue: 229.0/255.0, alpha: 1)
    nav?.tintColor = UIColor.whiteColor()
      nav!.barTintColor = UIColor(red: 142.0/255.0, green: 138.0/255.0, blue: 222.0/255.0, alpha: 1)     //  appearance. setBarTintColor:[UIColor yellowColor]];
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        

        let collection :UICollectionView = collectionView!;
       // collection.frame = screenBounds
        
        collection.frame = CGRectMake(10, 0, screenWidth-19, screenHeight)
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
       // collection.reloadData()
        
        
        
        getfavoritelist()

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    
        
        let image:UIImage! = swipedImages[indexPath.row]
        let imageHeight = image.size.height*gridWidth/image.size.width
        return CGSizeMake(gridWidth, imageHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var collectionCell: NTWaterfallViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(waterfallViewCellIdentify, forIndexPath: indexPath) as! NTWaterfallViewCell

        collectionCell.imageFile =  self.swipedImages[indexPath.row]
        
        collectionCell.setNeedsLayout()
        return collectionCell;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return swipedImages.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
       
        
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.imageFile = swipedImages
        pageViewController.pricelabel = pricelabel
        pageViewController.itemTitle = itemTitle
        pageViewController.itemDesc = itemDesc
        pageViewController.otherusers = otherUsers

        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
        
    
        
        
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
    
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition =
        .CenteredHorizontally & .CenteredVertically
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
        
        swipedImages.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        var query:PFQuery = PFQuery(className: "imageUpload")
        query.addAscendingOrder("createdAt")
       query.whereKey("interesting", equalTo: PFUser.currentUser()!.username!)
      //  query.whereKey("interesting", containsString: PFUser.currentUser()!.username!)
       // query.whereKey(PFUser.currentUser()!.username!, containedIn: "interesting")
        
   //     query.whereKey("user", notEqualTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                let objects = results as! [PFObject]
    
                for obj in objects{
                   // let itemTitle = obj["itemname"]! as! String
                    let itemDesc = obj["description"]! as! String
                    let pricelabel = obj["price"]! as! String
                    let otheruser = obj["user"] as! PFObject
                    println("other user uis \(otheruser.objectId!)")
                    self.otherUsers.append(otheruser.objectId!)
                                        let thumbNail = obj["image"] as! PFFile
                    thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) -> Void in
                        
                        if error2 == nil
                        {
                            let image = UIImage(data:imageData!)
                            //image object implementation
                            self.swipedImages.append(image!)
                          //  self.itemTitle.append(itemTitle)
                            self.itemDesc.append(itemDesc)
                            self.pricelabel.append(pricelabel)
                           // self.otherUsers.append(otheruser)
                            
                            var objId = obj.objectId! as String
                            self.otherObjID.append(objId)
                            if(objects.count == self.swipedImages.count ){
                                println("objects.count \(objects.count)")
                                println("otherImages \(self.swipedImages.count)")
                                  var collection :UICollectionView = self.collectionView!;
                                  collection.reloadData()
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
    }


}

