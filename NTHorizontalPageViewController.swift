//
//  NTHorizontalPageViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/1/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let horizontalPageViewCellIdentify = "horizontalPageViewCellIdentify"





class NTHorizontalPageViewController : UICollectionViewController, NTTransitionProtocol ,NTHorizontalPageViewControllerProtocol,CLLocationManagerDelegate{
    
    var popview : PagedScrollViewController!
    
    var indexnum : Int = Int()
    var imageFile = [UIImage]()
    var pricelabel = [String]()
    var itemTitle = [String]()
    var itemDesc = [String]()
    var otherObjID = [String]()

    var pullOffset = CGPointZero
    
    
    var PassButton :UIButton = UIButton()
    var LikeButton :UIButton  = UIButton()
    var itemNameLabel: UILabel = UILabel()
    var PriceLabel: UILabel = UILabel()
    var descLabel: UILabel = UILabel()
    var otherusers = [String]()

    
    
    var coreLocationManager = CLLocationManager()
  //  var locationManager : LocationManager!
    
    
    var map:MKMapView!  = MKMapView()
    
    
    
    
    
    
    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: NSIndexPath){
        super.init(collectionViewLayout:layout)
        let collectionView :UICollectionView = self.collectionView!;
        
        popview = PagedScrollViewController()

       
        var offsetY = screenHeight/2.2
        PassButton = UIButton(frame: CGRectMake(screenWidth*0.05, CGFloat(offsetY), screenWidth*0.4 , screenHeight/20))
        LikeButton = UIButton(frame: CGRectMake(screenWidth*0.5, CGFloat(offsetY), screenWidth*0.45 , screenHeight/20))
        
        
        PassButton.setTitle(" X Pass", forState: UIControlState.Normal)
        PassButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        PassButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        PassButton.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        
        PassButton.clipsToBounds = true
        PassButton.layer.cornerRadius = 10.0;
        PassButton.layer.borderColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0).CGColor
        PassButton.addTarget(self, action: "passButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        LikeButton.setTitle(" Like It", forState: UIControlState.Normal)
        LikeButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        LikeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        LikeButton.backgroundColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        LikeButton.clipsToBounds = true
        LikeButton.layer.cornerRadius = 10.0;
        LikeButton.layer.borderColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0).CGColor
        LikeButton.addTarget(self, action: "LikeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        offsetY+=(PassButton.frame.height)
        
        itemNameLabel = UILabel(frame: CGRectMake(screenWidth*0.01, offsetY, screenWidth*0.6 , screenHeight/26))
        PriceLabel = UILabel(frame: CGRectMake(screenWidth*0.52, offsetY, screenWidth*0.3, screenHeight/26))
        
        
        itemNameLabel.font = UIFont(name: "HevelticaNeue-UltraLight", size: 12)
        
        
        PriceLabel.text="123 "
        PriceLabel.font = UIFont(name: "HevelticaNeue-UltraLight", size: 12)
        PriceLabel.textAlignment = NSTextAlignment.Right;
        PriceLabel.textColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        
        offsetY+=(itemNameLabel.frame.height)
        descLabel = UILabel(frame: CGRectMake(screenWidth*0.01, offsetY, screenWidth*0.8, screenHeight/9))
        
        descLabel.text = "description"
        descLabel.font = UIFont(name: "HevelticaNeue-UltraLight", size: 10)

       // descLabel.sizeToFit()
        descLabel.numberOfLines = 5
       // descLabel.preferredMaxLayoutWidth = 150
        descLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        descLabel.textAlignment = NSTextAlignment.Left;
        descLabel.textColor = UIColor.blackColor()
        
        offsetY+=(descLabel.frame.height)
        map = MKMapView(frame: CGRectMake(0, offsetY, screenWidth, screenHeight/4))

        
        //  LabelFrame.addSubview(imageLabel)
        //  LabelFrame.addSubview(imageLabel2)
        //   self.view.addSubview(imageLabel)
        //self.view.addSubview(imageLabel2)

      //  self.view.addSubview(DistanceLabel)

        
        
        
        collectionView.pagingEnabled = true
        collectionView.registerClass(NTHorizontalPageViewCell.self, forCellWithReuseIdentifier: horizontalPageViewCellIdentify)
        collectionView.setToIndexPath(indexPath)
        collectionView.performBatchUpdates({collectionView.reloadData()}, completion: { finished in
            if finished {
                collectionView.scrollToItemAtIndexPath(indexPath,atScrollPosition:.CenteredHorizontally, animated: false)
            }});
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        coreLocationManager.delegate = self
    //    locationManager = LocationManager.sharedInstance
        
        let autorizationCode = CLLocationManager.authorizationStatus()
        if autorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") ||
        coreLocationManager.respondsToSelector("requestWhenInUseAuthorization")
        {
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil
            {
                coreLocationManager.requestAlwaysAuthorization()
            }
            else
            {
                print("No description Provided")
            }
        }
        else
        {
            getLocation()
        }
        
    }
    
    func getLocation()
    {
     //   locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
        //    self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
       // }
    }
    
    func displayLocation(location:CLLocation)
    {
    
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude),
            span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        map.addAnnotation(annotation)
        map.showAnnotations([annotation], animated: true)
        
        /*
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            print(reverseGecodeInfo)
            let addr = reverseGecodeInfo?.objectForKey("locality") as! String
            print("addr is \(addr)")
        })*/
 
    }
    
    
    /*
    func locationManager(manager: CLLocationManager!,didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined ||
           status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted
        {
            getLocation()
        }
    }
    
    */
    override func viewDidAppear(animated: Bool) {
        
       // NSNotificationCenter.defaultCenter().postNotificationName("loaditems", object: nil)

        getLocation()
        
        
        let reportButton = UIButton(frame: CGRectMake(0 , screenHeight-(screenHeight/12), screenWidth,screenHeight/12))
        reportButton.setTitle(" Report this product", forState: UIControlState.Normal)
        reportButton.titleLabel?.textAlignment = NSTextAlignment.Center;
        reportButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        reportButton.setTitleColor(UIColor(red: 181/255, green: 181/255, blue:181/255, alpha: 1.0), forState: UIControlState.Normal)
        reportButton.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        reportButton.addTarget(self, action: "reportButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        self.view.addSubview(PassButton)
        self.view.addSubview(LikeButton)
        self.view.addSubview(itemNameLabel)
        self.view.addSubview(PriceLabel)
        self.view.addSubview(descLabel)
        self.view.addSubview(map)
        self.view.addSubview(reportButton)
        
        
        
        
    }
    

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell: NTHorizontalPageViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalPageViewCellIdentify, forIndexPath: indexPath) as! NTHorizontalPageViewCell
      //  collectionCell.imageName = self.imageNameList[indexPath.row] as String
        
        collectionCell.imageFile = self.imageFile[indexPath.row]
        
      //  itemNameLabel.text = pricelabel[indexPath.row]
        indexnum = indexPath.row
        self.PriceLabel.text = pricelabel[indexPath.row]as String
        self.descLabel.text = itemDesc[indexPath.row] as String

        collectionCell.tappedAction = {}
        collectionCell.pullAction = { offset in
            self.pullOffset = offset
           // self.navigationController!.popViewControllerAnimated(true)
            detailImages.removeAll(keepCapacity: false)
            let query = PFQuery(className:"Post")
            query.whereKey("obj_ptr", equalTo: PFObject(withoutDataWithClassName:"imageUpload", objectId:self.otherObjID[indexPath.row]))
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
        collectionCell.setNeedsLayout()
        return collectionCell
    }
    
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageFile.count;
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    func pageViewCellScrollViewContentOffset() -> CGPoint{
        return self.pullOffset
    }
    func LikeButtonPressed(sender:UIButton!)
    {
        print("indexnum \(indexnum)")
        if PFUser.currentUser() != nil{
            let user1 = PFUser.currentUser()!
            let query2 = PFQuery(className: "_User")
            query2.whereKey("objectId", equalTo: otherusers[indexnum])
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let messageVC = sb.instantiateViewControllerWithIdentifier("MessageViewController") as? MessageViewController
            

            
            query2.findObjectsInBackgroundWithBlock({ (result, error1) -> Void in
                if error1 == nil
                {
                    if let userObject: AnyObject = result?[0] {
                        let user2 = userObject as! PFUser
                        
                        var room = PFObject(className: "Room")
                        
                        let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
                        let roomQuery = PFQuery(className:"Room", predicate: pred)
                        roomQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                            if error == nil
                            {
                                if results!.count > 0
                                {
                                    room = results?.last as! PFObject
                                    messageVC!.room = room
                                    messageVC?.incomingUser = user2
                                    self.navigationController?.pushViewController(messageVC!, animated: true)
                                    
                                }
                                else
                                {
                                    room["user1"] = user1
                                    room["user2"] = user2
                                    
                                    room.saveInBackgroundWithBlock({ (success, error) -> Void in
                                        if error == nil{
                                            messageVC!.room = room
                                            messageVC?.incomingUser = user2
                                            
                                            /* msg send */
                                            let message = PFObject(className: "Message")
                                            message["content"] = "i am interesting in product";
                                            message["room"] = room
                                            message["user"] = PFUser.currentUser()!
                                            
                                            let msgACL = PFACL()
                                            msgACL.setReadAccess(true, forRoleWithName: user1.objectId!)
                                            msgACL.setReadAccess(true, forRoleWithName: user2.objectId!)
                                            msgACL.setWriteAccess(true, forRoleWithName: user1.objectId!)
                                            msgACL.setWriteAccess(true, forRoleWithName: user2.objectId!)
                                            
                                            message.ACL = msgACL
                                            
                                            message.saveInBackgroundWithBlock { (success, error) -> Void in
                                                if error == nil
                                                {
                                                  //  self.loadMessages()
                                                    
                                                    let pushQuery = PFInstallation.query()
                                                    pushQuery?.whereKey("user", equalTo: user2)
                                                    
                                                    let push = PFPush()
                                                    push.setQuery(pushQuery)
                                                    
                                                    let pushDict = ["alert":"i am interesting in product", "badge":"increment","sound":""]
                                                    push.setData(pushDict)
                                                    
                                                    push.sendPushInBackgroundWithBlock(nil)
                                                    
                                                    
                                                    room["lastUpdate"] = NSDate()
                                                    room.saveInBackgroundWithBlock(nil)
                                                    
                                                    let unreadMsg = PFObject(className: "UnreadMessage")
                                                    unreadMsg["user"] = user2
                                                    unreadMsg["room"] = room
                                                    
                                                    unreadMsg.saveInBackgroundWithBlock(nil)
                                                    
                                                    
                                                }
                                                else
                                                {
                                                    
                                                    print("Error sending msg\(error?.localizedDescription)")
                                                    
                                                }
                                                
                                               // self.finishSendingMessage()
                                            }

                                            
                                            
                                           self.navigationController?.popToViewController(messageVC!, animated: true)
                                        }
                                        
                                    })
                                }
                                
                                
                            }
                            
                        })
                        
                        
                    }
                   
                    
                    
             
                }
            })
            
            
            
  
        }
        
    }
    

    
}