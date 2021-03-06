//
//  NTHorizontalPageViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/1/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics;

import MapKit

let horizontalPageViewCellIdentify = "horizontalPageViewCellIdentify"


class NTHorizontalPageViewController : UICollectionViewController, NTTransitionProtocol ,NTHorizontalPageViewControllerProtocol,CLLocationManagerDelegate,MKMapViewDelegate{
    
    var popview : PagedScrollViewController!
    
    var indexnum : Int = Int()
    var imageFile = [UIImage]()
    var pricelabel = [Int]()
    var currency = [String]()
    var itemTitle = [String]()
    var itemDesc = [String]()
    var otherObjID = [String]()
    var otherlocation =  [PFGeoPoint]()

    
    var pullOffset = CGPointZero
    
    
    var PassButton :UIButton = UIButton()
    var LikeButton :UIButton  = UIButton()
    var itemNameLabel: UILabel = UILabel()
    var PriceLabel: UILabel = UILabel()
    var descLabel: UILabel = UILabel()
    var locationLabel: UILabel = UILabel()
    var locationimage: UIImageView = UIImageView()


    var otherusers = [String]()


    var coreLocationManager = CLLocationManager()
    var locationManager : LocationManager!
    
    var local = ""
     var sublocal = ""
    var map:MKMapView!  = MKMapView()
    
    var NameLabel: UILabel!

   var profileimageView: UIImageView!

    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: NSIndexPath){
        super.init(collectionViewLayout:layout)
        let collectionView :UICollectionView = self.collectionView!;
        
        collectionView.backgroundColor = UIColor.whiteColor()
        popview = PagedScrollViewController()

      //  collectionView.frame = (frame: CGRectMake(0, 0, screenWidth , screenHeight*0.5))
        var offsetY = screenHeight/2.2
        PassButton = UIButton(frame: CGRectMake(screenWidth*0.02, CGFloat(offsetY), screenWidth*0.4 , screenHeight/20))
        LikeButton = UIButton(frame: CGRectMake(screenWidth*0.45, CGFloat(offsetY), screenWidth*0.53 , screenHeight/20))
        
        
        PassButton.setTitle(" I Will Pass", forState: UIControlState.Normal)
        PassButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 40.0)
        PassButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        PassButton.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        
        PassButton.clipsToBounds = true
        PassButton.layer.cornerRadius = 10.0;
        PassButton.layer.borderColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0).CGColor
        PassButton.addTarget(self, action: "passButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        LikeButton.setTitle(" Chat With A Seller", forState: UIControlState.Normal)
        LikeButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 40.0)
        LikeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        LikeButton.backgroundColor = backgroundColor
        
        LikeButton.clipsToBounds = true
        LikeButton.layer.cornerRadius = 10.0;
        LikeButton.layer.borderColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0).CGColor
        LikeButton.addTarget(self, action: "LikeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        offsetY+=(PassButton.frame.height)
        
        itemNameLabel = UILabel(frame: CGRectMake(screenWidth*0.02, offsetY, screenWidth*0.6 , screenHeight/27))
        PriceLabel = UILabel(frame: CGRectMake(screenWidth*0.52, offsetY, screenWidth*0.3, screenHeight/27))
        
        itemNameLabel.font = UIFont.boldSystemFontOfSize(14)
        
        PriceLabel.text="$123 "
        PriceLabel.textAlignment = NSTextAlignment.Right;
        PriceLabel.textColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        
        offsetY+=(itemNameLabel.frame.height)
        descLabel = UILabel(frame: CGRectMake(screenWidth*0.02, offsetY, screenWidth*0.8, screenHeight/12))
        descLabel.text = "description"

       
        
        offsetY+=(descLabel.frame.height)
       profileimageView  = UIImageView(frame: CGRectMake(screenWidth*0.02,offsetY, 30,30))
        
      // profileimageView.frame = CGRectMake(screenWidth*0.05,screenWidth*0.3, 50,50)
      //  profileimageView.center  = CGPointMake(self.imageViewContent.frame.width/6, (self.imageViewContent.frame.height)*0.9)
        profileimageView.layer.cornerRadius = profileimageView.frame.size.width/2
        profileimageView.clipsToBounds = true
        
        // self.profileimage.image = UIImage(data:data!)
        
        
        profileimageView.image = UIImage(named: "centerImage_blue")
        
        
        
        var offsetX = profileimageView.frame.width + screenWidth*0.04
        
        
        NameLabel = UILabel(frame: CGRectMake(offsetX, offsetY, screenWidth*0.2, screenHeight/22))
        NameLabel.font = UIFont.systemFontOfSize(13.0);
        NameLabel.textColor = UIColor(red: 67/255.0, green: 178/225.0, blue: 229/255.0, alpha: 1)
      //  nameLabel.textAlignment = NSTextAlignment.Left;
        NameLabel.text = "aaaaa"
        
        offsetX+=NameLabel.frame.width
        
        locationLabel = UILabel(frame: CGRectMake(screenWidth*0.5, offsetY, screenWidth*0.48, screenHeight/22))
        
        locationLabel.font = UIFont.systemFontOfSize(12.0);
        locationLabel.textColor = UIColor.lightGrayColor()
        locationLabel.textAlignment = NSTextAlignment.Right;
   ///   locationimage.image = UIImage(data: location.svg)
        
        offsetY+=(locationLabel.frame.height+5)
        map = MKMapView(frame: CGRectMake(0, offsetY, screenWidth, screenHeight/5))

   
        
        let rightbutton  = UIBarButtonItem(title: "Flag", style: .Plain, target: self, action: Selector("reportPressed:"))
        rightbutton.tintColor = UIColor.whiteColor()
     //   let barButtonItemApperance = UIBarButtonItem.appearance()
     //   barButtonItemApperance.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Apple SD Gothic Neo", size: 19)!], forState: UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = rightbutton
        
        
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


        
        self.view.backgroundColor = UIColor.whiteColor()
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "icon_arrow_left.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 20, 20)
        btnName.addTarget(self, action: Selector("leftpressed"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftbutton:UIBarButtonItem = UIBarButtonItem()
        leftbutton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftbutton
        
        
        coreLocationManager.delegate = self
       locationManager = LocationManager.sharedInstance
        
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
           // getLocation()
        }
        
    }
    /*
    func getLocation()
    {
       locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
          self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        
        
      }
    }
    func displayLocation(location:CLLocation)
    {
    
       // map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude),
          //  span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
       // let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
       // let annotation = MKPointAnnotation()
       // annotation.coordinate = locationPinCoord
       // map.addAnnotation(annotation)
       // map.showAnnotations([annotation], animated: true)
        
        
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            print(reverseGecodeInfo)
            let addr = reverseGecodeInfo?.objectForKey("locality") as! String
            print("addr is \(addr)")
        })
 
    }
    */
    
   
    func locationManager(manager: CLLocationManager,didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined ||
           status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted
        {
         //   getLocation()
        }
    }
    
 
    override func viewDidAppear(animated: Bool) {
        
       // NSNotificationCenter.defaultCenter().postNotificationName("loaditems", object: nil)

        //getLocation()

        
        self.view.addSubview(PassButton)
        self.view.addSubview(LikeButton)
        self.view.addSubview(itemNameLabel)
        self.view.addSubview(PriceLabel)
        self.view.addSubview(descLabel)
        self.view.addSubview(locationLabel)
        self.view.addSubview(NameLabel)
       // self.view.addSubview(locationimage)
        self.view.addSubview(profileimageView)

        self.view.addSubview(map)
        
    }
    

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay.isKindOfClass(MKCircle){
         //   var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            let circleRender = MKCircleRenderer(overlay: overlay)
          //  circleRender.strokeColor = UIColor.blueColor()
          //  circleRender.lineWidth = 2
            circleRender.fillColor = UIColor(red: 156/255, green: 173/255, blue: 225/255, alpha: 0.5)
            return circleRender
        }
        
        return nil
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell: NTHorizontalPageViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalPageViewCellIdentify, forIndexPath: indexPath) as! NTHorizontalPageViewCell
      //  collectionCell.imageName = self.imageNameList[indexPath.row] as String
        map.delegate = self
        
        collectionCell.imageFile = self.imageFile[indexPath.row]
        indexnum = indexPath.row
        
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
            price_display = "\(currency_exchange)원"
            
            }
        }
        else
        {
            price_display = "\(self.pricelabel[indexPath.row])"
        }
        
              self.PriceLabel.text = "\(currency[indexPath.row])\(price_display)"
        
        self.descLabel.text = itemDesc[indexPath.row]
        descLabel.numberOfLines = 0

        descLabel.font = UIFont.systemFontOfSize(12)
        descLabel.lineBreakMode = NSLineBreakMode.ByClipping
        descLabel.textAlignment = NSTextAlignment.Left;
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.preferredMaxLayoutWidth = self.view.frame.width*0.8
        descLabel.numberOfLines = 0


        self.itemNameLabel.text = itemTitle[indexPath.row] as String

        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: otherusers[indexPath.row])
        query.findObjectsInBackgroundWithBlock { (result, Error) -> Void in
            
            if(Error == nil)
            {
                for obj in result! {
                   self.NameLabel.text = obj.username as String!
                   // self.NameLabel.text = "asdfsadF"
                    print("obj.username \(obj.username)")
                    if let userImageFile = obj["profileImage"] as? PFFile {
                        userImageFile.getDataInBackgroundWithBlock { (data, error3) -> Void in
                            if error3 == nil{
                                let profileImage = UIImage(data:data!)
                                //self.profileimage.append(profileImage!)
                                self.profileimageView.image = profileImage
                                
                            }
                        }
                    }
                }
                
                
            }
            
            
            
            
        }

        // Determine other user's location
        let location = CLLocationCoordinate2D(latitude: otherlocation[indexPath.row].latitude,longitude: otherlocation[indexPath.row].longitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        let locationFromGeoPoint: CLLocation  = CLLocation(latitude: location.latitude, longitude: location.longitude)
        locationManager.reverseGeocodeLocationWithCoordinates(locationFromGeoPoint, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            if( reverseGecodeInfo != nil){
                self.local = reverseGecodeInfo?.objectForKey("locality") as! String
                self.sublocal = reverseGecodeInfo?.objectForKey("subLocality") as! String

                self.locationLabel.text = self.local+","+self.sublocal
            }
        })

    
        
      let newCircle = MKCircle(centerCoordinate: location, radius: 200 as CLLocationDistance)
       map.removeOverlays(self.map.overlays)
       map.addOverlay(newCircle)
        
        
        
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

    func leftpressed()
    {
   
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func passButtonPressed(sender:UIButton!)
    {
        
        let imageDBTable: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: otherObjID[self.indexnum] as String)
        imageDBTable.addUniqueObject(PFUser.currentUser()!.username!, forKey:"passed")
        
        imageDBTable.saveEventually({ (success, error) -> Void in
            if success == true {
                
                let alert = UIAlertController(title: "I will pass this time", message: self.itemTitle[self.indexnum] as String, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                update_status = true

            }
        })
        
        
        
        
        
    }
    
    func reportPressed(sender:UIBarButtonItem){
        
        let uiAlert = UIAlertController(title: "Block Content", message: "Are you sure you want to report this content and user?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { action in
            
            let query = PFQuery(className:"imageUpload")
            query.whereKey("objectId", equalTo:self.otherObjID[self.indexnum])
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error == nil
                {
                        let obj = results?.last as? PFObject
                        obj!.addUniqueObject(PFUser.currentUser()!.username!, forKey:"Block")
                        obj!.saveInBackgroundWithBlock { (success, error) -> Void in
                        if(error == nil)
                        {
                            print(" blcoked ")
                            block_trigger = true
                            self.navigationController?.popViewControllerAnimated(true)

                                update_status = true
                            
                        }
                    }

                }
            })

            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            print("Click of cancel button")
        }))

    }
    func LikeButtonPressed(sender:UIButton!)
    {
        
        let query:PFQuery = PFQuery(className: "imageUpload")
        query.whereKey("objectId", equalTo: otherObjID[self.indexnum] as String)
      query.whereKey("passed", equalTo: PFUser.currentUser()!.username!)
       // query.whereKey("passed", containsString: PFUser.currentUser()!.username!)
        print(otherObjID[self.indexnum])
        query.findObjectsInBackgroundWithBlock { (result, error) -> Void in
            if error == nil
            {
                if result!.count > 0
                {
            
                    let alert = UIAlertController(title: "Error", message: "You already have passed this product ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
                    
                }
                else
                {
                    
                    let imageDBTable: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: self.otherObjID[self.indexnum] as String)
                    imageDBTable.addUniqueObject(PFUser.currentUser()!.username!, forKey:"chat")
                    imageDBTable.saveEventually({ (success, error) -> Void in
                        if success == true {
                            update_status = true
                            let query_user = PFQuery(className: "imageUpload")
                            query_user.whereKey("objectId", equalTo: self.otherObjID[self.indexnum] )
                            query_user.includeKey("user")
                            query_user.findObjectsInBackgroundWithBlock({ (result_user, err) -> Void in
                                if( err == nil )
                                {
                                    print("result_user is \(result_user)")
                                    //      if let userObject = result_user as? PFObject{
                                    if let userObject = result_user!.last as? PFObject!{
                                        let user2 = userObject.objectForKey("user") as! PFUser!
                                        
                                        if PFUser.currentUser() != nil{
                                            let user1 = PFUser.currentUser()!
                                            
                                            let sb = UIStoryboard(name: "Main", bundle: nil)
                                            let messageVC = sb.instantiateViewControllerWithIdentifier("MessageViewController") as? MessageViewController
                                            
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
                                                        
                                                        
                                                        messageVC!.room = room
                                                        messageVC?.incomingUser = user2
                                                        //  messageVC?.itemImageObj = self.otherObjID[self.indexnum]
                                                        
                                                        /* msg send */
                                                        let message = PFObject(className: "Message")
                                                        message["content"] = user1.username! + " is interesting in your " + self.itemTitle[self.indexnum] ;
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
                                                                
                                                                let pushDict = ["alert":"\(user1.username!)"+": Hi! I interesting your Item" , "badge":"increment","sound":""]
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
                                                        }
                                                        // print("userlocation \(self.locationLabel.text)")
                                                        
                                                        //  messageVC?.userlocation = self.locationLabel.text
                                                        self.navigationController?.pushViewController(messageVC!, animated: true)
                                                        
                                                    }
                                                    else
                                                    {
                                                        room["user1"] = user1
                                                        room["user2"] = user2
                                                        
                                                        //
                                                        // room["item"] = self.otherObjID[self.indexnum]
                                                        
                                                        room.saveInBackgroundWithBlock({ (success, error) -> Void in
                                                            if error == nil{
                                                                messageVC!.room = room
                                                                messageVC?.incomingUser = user2
                                                                //  messageVC?.itemImageObj = self.otherObjID[self.indexnum]
                                                                
                                                                /* msg send */
                                                                let message = PFObject(className: "Message")
                                                                message["content"] = "Hi !I am interesting in " + self.itemTitle[self.indexnum];
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
                                                                        
                                                                        let pushDict = ["alert":"I am interesting in product", "badge":"increment","sound":""]
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
                                                                    self.navigationController?.pushViewController(messageVC!, animated: true)
                                                                    
                                                                }

                                                            }
                                                            
                                                        })
                                                    }
                                                }
                                                
                                            })
                                            
                                            
                                        }
                                    }
                                    
                                }
                                
                            })
                        }
                    })
                }
            
            }
        }

        ///   query.whereKey("passed", notEqualTo: PFUser.currentUser()!.username!)
        
        
    }

}