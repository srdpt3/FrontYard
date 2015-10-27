//
//  SwapItMainViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/29/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.


import UIKit
import Koloda
import pop

//var numberOfCards: UInt = UInt(imagesToswipe.count)

class SwapItMainViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    var popview : PagedScrollViewController!
    @IBOutlet weak var kolodaView: KolodaView!
    
    var obj : NTWaterfallViewController!
    var multiLayer:PulsingHaloLayer!
    var multiLayer2:PulsingHaloLayer!
    var multiLayer3:PulsingHaloLayer!
    var multiLayer4:PulsingHaloLayer!
    
    @IBOutlet var NoButton: UIButton!
    
    @IBOutlet var YesButton: UIButton!
    var userImage: UIImageView!
    
    var index2:Int = 0
    var remainingCards: Int = 0
    
    var finishLoading : Bool = false

    override func viewDidAppear(animated: Bool) {
        remainingCards = Int(numberOfCards)
        print("numberOfCards \(numberOfCards)")
        print("remainingCards \(remainingCards)")

        
        
        multiLayer = PulsingHaloLayer()
        multiLayer2 = PulsingHaloLayer()
        multiLayer3 = PulsingHaloLayer()
        multiLayer4 = PulsingHaloLayer()
        
        if numberOfCards == 0
        {
            YesButton.alpha = 0
            NoButton.alpha = 0
            playpulse()
            loadMoreImages()
        }
       

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 

        
        
        self.view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        userImage = UIImageView(frame: CGRectMake(50, 0, self.view.frame.width-100, self.view.frame.height-100))
        popview = PagedScrollViewController()
        kolodaView.dataSource = self
        kolodaView.delegate = self

   //  self.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)

        // loader.hide()
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }

    
    override func viewWillAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        let navBarHeight = nav?.frame.height
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        
        nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        self.view.backgroundColor = UIColor.whiteColor()
       // nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
       // nav?.barTintColor = backgroundColor
        
        
        let logoImage = UIImageView(frame: CGRectMake(0 , 0, self.view.frame.size.width*0.1, navBarHeight!))
        logoImage.image = UIImage(named: "vendee_logo.png")
        logoImage.contentMode = .Center
        logoImage.contentMode = UIViewContentMode.ScaleAspectFit
      //  logoButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
        self.navigationItem.titleView = logoImage
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit


        
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)

    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return numberOfCards
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
       
        let imageView = UIImageView(frame: CGRectMake(0, 0, koloda.frame.size.width, koloda.frame.size.height))
        imageView.backgroundColor = UIColor.whiteColor()
        

        
        imageView.autoresizingMask  = UIViewAutoresizing.FlexibleBottomMargin.union(UIViewAutoresizing.FlexibleHeight).union(UIViewAutoresizing.FlexibleRightMargin).union(UIViewAutoresizing.FlexibleLeftMargin).union(UIViewAutoresizing.FlexibleTopMargin ).union(UIViewAutoresizing.FlexibleWidth)
        
    //   imageView.contentMode = UIViewContentMode.ScaleAspectFill

        index2 = Int(index)
        print(index2)
     // imageView.image = UIImage(named: "Card_like_\(index + 1)")!
     if(imagesToswipe.count > 0)
     {
            imageView.image = imagesToswipe[index2]
        
            imageView.layer.cornerRadius = 5
            imageView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
      //  imageView.layer.borderColor = UIColor.clearColor().CGColor
            imageView.layer.borderWidth = 2;
        
            imageView.clipsToBounds = true
    }
    else
    {
         self.kolodaDidRunOutOfCards(self.kolodaView)
    }
        return imageView

        
    }
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        //Example: loading more cards
       if index >= 1 {
          // numberOfCards = 7
            kolodaView.reloadData()
        }

        print("direction is \(direction.hashValue)")
        
        if (direction.hashValue == 2)
        {
            let imageDBTable: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: otherObjID[Int(index)] as String)
            imageDBTable.addUniqueObject(PFUser.currentUser()!.username!, forKey:"interesting")
            
            imageDBTable.saveEventually({ (success, error) -> Void in
                if success == true {
                    print("You liked: \(otherObjID[Int(index)])")
                    self.remainingCards--
                    if(self.remainingCards == 0){
                        numberOfCards = UInt(self.remainingCards)

                        self.kolodaDidRunOutOfCards(self.kolodaView)
                    }
                }
            })
       
        }
        else if (direction.hashValue == 1)
        {
            let imageDBTable: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: otherObjID[Int(index)] as String)
            imageDBTable.addUniqueObject(PFUser.currentUser()!.username!, forKey:"passed")
            
            imageDBTable.saveEventually({ (success, error) -> Void in
                if success == true {
                    print("You passed: \(otherObjID[Int(index)])")
                    self.remainingCards--
                    if(self.remainingCards == 0){
                        numberOfCards = UInt(self.remainingCards)
                        self.kolodaDidRunOutOfCards(self.kolodaView)
                        
                    }
                    
                }
            })
            
        }

    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        print("no card")
        YesButton.alpha = 0
        NoButton.alpha = 0

        if(remainingCards == 0){
            playpulse()
            loadMoreImages()
        }

   //     kolodaView.resetCurrentCardNumber()
        
    }
    
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
       // UIApplication.sharedApplication().openURL(NSURL(string: "http://us.blizzard.com/en-us/games/hots/landing/")!)
        
        
        
        
        detailImages.removeAll(keepCapacity: false)
        let query = PFQuery(className:"Post")
        query.whereKey("obj_ptr", equalTo: PFObject(withoutDataWithClassName:"imageUpload", objectId:otherObjID[Int(index)]))
        query.addAscendingOrder("createdAt")
        //query.whereKey("obj_ptr", equalTo: objID[indexPath.row])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error  == nil
            {
                for obj in objects!{
                    let thumbNail = obj["images"] as! PFFile
                    thumbNail.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            detailImages.append(image!)
                            if(detailImages.count == objects!.count )
                            {
                                print("detailImages.count\(detailImages.count)")
                                self.popview.showInView(self.view, animated: true)

                            }
                            
                            
                        }
                    })//getDataInBackgroundWithBlock - end
                }
                
                
                
            }
            
        }
        

      
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        return nil
    }
    

    /*
    
    func loadMoreImages(index: Int)
    {
        
        
        detailImages.removeAll(keepCapacity: false)
        let query = PFQuery(className:"Post")
        query.whereKey("obj_ptr", equalTo: PFObject(withoutDataWithClassName:"imageUpload", objectId:otherObjID[index]))
        query.addAscendingOrder("createdAt")
        //query.whereKey("obj_ptr", equalTo: objID[indexPath.row])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error  == nil
            {
                print("count is \(objects!.count)")
                
                //  println(["obj_ptr"])")
                for obj in objects!{
                    let thumbNail = obj["images"] as! PFFile
                    thumbNail.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            detailImages.append(image!)
                            if(detailImages.count == objects!.count )
                            {
                               /* do something */
                            }
                            
                            
                        }
                    })//getDataInBackgroundWithBlock - end
                }
                
                
                
            }
            
        }

    }*/
    override func viewWillDisappear(animated: Bool) {
    }
    func playpulse()
    {
        let currentUser = PFUser.currentUser()!
        
        if let selfProfileImageFile = currentUser["profileImage"] as? PFFile{
                selfProfileImageFile.getDataInBackgroundWithBlock({ (result, error) -> Void in
                    if error == nil
                    {
                            let selfImage = UIImage(data: result!)
                            self.userImage.image = selfImage
                    }
                })
        }
        

        
        multiLayer2.radius = 40
        multiLayer3.radius = 130
        multiLayer4.radius = 180
        
        multiLayer.position = userImage.center;
        multiLayer2.position = userImage.center;
        multiLayer3.position = userImage.center;
        multiLayer4.position = userImage.center;
        
        view.layer.insertSublayer(multiLayer, below: userImage.layer)
        view.layer.insertSublayer(multiLayer2, below: userImage.layer)
        view.layer.insertSublayer(multiLayer3, below: userImage.layer)
        view.layer.insertSublayer(multiLayer4, below: userImage.layer)
        
        
        //view.layer.insertSublayer(multiLayer, below: userImage.layer)
        
    }

    func stoppulse()
    {
        multiLayer.removeFromSuperlayer()
        multiLayer2.removeFromSuperlayer()
        multiLayer3.removeFromSuperlayer()
        multiLayer4.removeFromSuperlayer()
        userImage.removeFromSuperview()
    }
    
    func loadMoreImages()
    {
        imagesToswipe.removeAll(keepCapacity: false)
        otherObjID.removeAll(keepCapacity: false)
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                PFUser.currentUser()!.setValue(geoPoint, forKey: "location")
                PFUser.currentUser()!.saveInBackground()
                
                let query = PFUser.query()!
                query.whereKey("location", nearGeoPoint:geoPoint!)
                query.whereKey("username",notEqualTo: PFUser.currentUser()!.username!)
                query.limit = 100
                
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    if error == nil
                    {

                        let query2:PFQuery = PFQuery(className: "imageUpload")
                        query2.addAscendingOrder("createdAt")
                        query2.whereKey("minPrice", greaterThanOrEqualTo: minPrice)
                        query2.whereKey("maxPrice", lessThanOrEqualTo: maxPrice)
                        query2.whereKey("user",notEqualTo: PFUser.currentUser()!)
                        query2.whereKey("user", containedIn: users as! [PFUser])
                        query2.whereKey("passed", notEqualTo: PFUser.currentUser()!.username!)
                        query2.whereKey("interesting", notEqualTo: PFUser.currentUser()!.username!)
                        query2.whereKey("chat", notEqualTo: PFUser.currentUser()!.username!)
                        
                        query2.findObjectsInBackgroundWithBlock { (results, error2) -> Void in
                            if error2 == nil
                            {
                                print("results!.count\(results!.count)")

                                self.finishLoading = true
                                let objects = results as! [PFObject]
                                for obj in objects{
                                    let thumbNail = obj["image"] as! PFFile
                                    thumbNail.getDataInBackgroundWithBlock({ (imageData, error2) -> Void in
                                        if error2 == nil
                                        {
                                            let image = UIImage(data:imageData!)
                                            imagesToswipe.append(image!)
                                            let objId = obj.objectId! as String
                                            otherObjID.append(objId)
                                            
                                            if(results!.count == imagesToswipe.count ){
                                                
                                                self.stoppulse()
                                                numberOfCards = UInt(imagesToswipe.count)
                                                self.remainingCards = Int(numberOfCards)

                                                self.kolodaView.resetCurrentCardNumber()
                                                
                                                self.NoButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
                                                self.YesButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
                                                

                                                UIView.animateWithDuration(2.0,
                                                    delay: 0,
                                                    usingSpringWithDamping: 0.20,
                                                    initialSpringVelocity: 6.00,
                                                    options: UIViewAnimationOptions.AllowUserInteraction,
                                                    animations: {
                                                        self.YesButton.alpha = 1
                                                        self.NoButton.alpha = 1

                                                        self.NoButton.transform = CGAffineTransformIdentity
                                                        self.YesButton.transform = CGAffineTransformIdentity
                                                        
                                                    }, completion: nil)
                                                
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                }
                                
                            }
                            else
                            {
                                print("erorr in getfavoritelist ")
                            }
                            
                            //  }
                            
                            
                        }
                        
                        
                    }
                    
                    
                })
                
                
            }
        }
        
    }
    
    
}

