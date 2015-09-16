//
//  SwapItMainViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/29/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.


import UIKit
import Koloda
import pop
import LiquidLoader
import JTSplashView

//var numberOfCards: UInt = UInt(imagesToswipe.count)

class SwapItMainViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        println("numberOfCards \(numberOfCards)")
        kolodaView.dataSource = self
        kolodaView.delegate = self
        

      //  self.view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
 
        // loader.hide()
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }

    
    override func viewWillAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        
        nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        // nav?.backgroundColor = UIColor(red: 85/255, green: 178/255, blue: 229/255, alpha: 1.0)
        
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        
        var followButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
        //followButton.setTitle(" Swit", forState: UIControlState.Normal)
        followButton.setImage(UIImage(named: "mainlogo.png.gif"), forState: UIControlState.Normal)
        followButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 25.0)
        followButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
        followButton.addTarget(self, action: "FrontYard:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.navigationItem.titleView = followButton
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
       
        var imageView = UIImageView(frame: CGRectMake(0, 0, koloda.frame.size.width, koloda.frame.size.height))
        imageView.backgroundColor = UIColor.whiteColor()
        
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        
    //   imageView.contentMode = UIViewContentMode.ScaleAspectFill

            var index2 = Int(index)
        println(index2)
     // imageView.image = UIImage(named: "Card_like_\(index + 1)")!
        imageView.image = imagesToswipe[index2]
        
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
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

        println("direction is \(direction.hashValue)")

    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        println("no card")
        kolodaView.resetCurrentCardNumber()
        
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "starcraft.com")!)
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
    


}

