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
    var index2:Int = 0
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        popview = PagedScrollViewController()
        print("numberOfCards \(numberOfCards)")
        kolodaView.dataSource = self
        kolodaView.delegate = self
      //  self.view.backgroundColor = UIColor.grayColor()

     self.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)

        // loader.hide()
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }

    
    override func viewWillAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        
        nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        // nav?.backgroundColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        self.view.backgroundColor = UIColor.whiteColor()
     //   self.navigationItem.title = "My Favorites"
        nav?.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0 , blue: 149.0/255.0, alpha: 1)
        nav?.barTintColor = backgroundColor
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        
        
        
        
      //  let followButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
        //followButton.setTitle(" Swit", forState: UIControlState.Normal)
     ///   followButton.setImage(UIImage(named: "mainlogo.png.gif"), forState: UIControlState.Normal)
     //  followButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 25.0)
      //  followButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
      //  followButton.addTarget(self, action: "FrontYard:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
      //  self.navigationItem.titleView = followButton
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
        imageView.image = imagesToswipe[index2]
        
        imageView.layer.cornerRadius = 5
       imageView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
      //  imageView.layer.borderColor = UIColor.clearColor().CGColor
        imageView.layer.borderWidth = 2;
        
        imageView.clipsToBounds = true

        
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
        // index2 = Int(index)
        
        if (direction.hashValue == 2)
        {
            let imageDBTable: PFObject = PFObject(withoutDataWithClassName: "imageUpload", objectId: otherObjID[Int(index)] as String)
            imageDBTable.addUniqueObject(PFUser.currentUser()!.username!, forKey:"interesting")
            
            imageDBTable.saveEventually({ (success, error) -> Void in
                if success == true {
                    print("You liked: \(otherObjID[Int(index)])")
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
                }
            })
            
        }

    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        print("no card")
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
        
        
        
        
    }
    override func viewWillDisappear(animated: Bool) {
    }
    

}

