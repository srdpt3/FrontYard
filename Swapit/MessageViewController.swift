//
//  MessageViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/13/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import FoldingTabBar


class MessageViewController:JSQMessagesViewController {
    
    
    var room:PFObject!
    var incomingUser : PFUser!
    var users = [PFUser]()
    
    var messages = [JSQMessage]()
    var messageObjects = [PFObject]()
    
    var outgoingBubbleImage :JSQMessagesBubbleImage!
    var incomingBubbleImage :JSQMessagesBubbleImage!
    
    var selfAvartar : JSQMessagesAvatarImage!
    var incomingAvartar: JSQMessagesAvatarImage!
    
    var likedImageView : UIView = UIView()

    
    
    var whatIinterested : [UIImage] = []
    var whatOthersinterested : [UIImage] = []
    
    override func viewWillAppear(animated: Bool) {
        
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = true
        self.tabBarController?.tabBar.hidden = true
        
        
        self.title = "Messages"
        self.senderId = PFUser.currentUser()!.objectId
        self.senderDisplayName = PFUser.currentUser()!.username
        
        let currentUser = PFUser.currentUser()!
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        
        let selfUsername = PFUser.currentUser()!.username! as NSString
        let incomingUsername = incomingUser.username! as NSString
        
        selfAvartar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(selfUsername.substringWithRange(NSMakeRange(0, 2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        incomingAvartar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(incomingUsername.substringWithRange(NSMakeRange(0, 2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        //Chat image
        //   let selfProfileImageFile = PFUser.currentUser()["profileImage"] as? PFFile!
        // let otherUserProfileImageFile = incomingUser["profileImage"] as? PFFile!
        
        if let selfProfileImageFile = currentUser["profileImage"] as? PFFile{
            if  let otherUserProfileImageFile = incomingUser["profileImage"] as? PFFile
            {
                selfProfileImageFile.getDataInBackgroundWithBlock({ (result, error) -> Void in
                    
                    if error == nil
                    {
                        
                        otherUserProfileImageFile.getDataInBackgroundWithBlock({ (result2, error2) -> Void in
                            if error2 == nil
                            {
                                let selfImage = UIImage(data: result!)
                                let incomingImage = UIImage(data: result2!)
                                
                                self.selfAvartar = JSQMessagesAvatarImageFactory.avatarImageWithImage(selfImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
                                self.incomingAvartar = JSQMessagesAvatarImageFactory.avatarImageWithImage(incomingImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
                                
                            }
                        })
                        
                    }
                    
                    
                })
                
            }
            
            
        }
        
        
        
        
        
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red: 156/255, green: 173/255, blue: 225/255, alpha: 1.0))
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
        
        //  dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.loadMessages()
        // })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedImageView.frame  = CGRectMake(0, 0, screenWidth, screenHeight*0.2)
        likedImageView.backgroundColor = UIColor.whiteColor()
    
        
       var xOffset  = screenWidth*0.03 as CGFloat
        for (_,image) in whatIinterested.enumerate()
        {
            generateButton(xOffset, image: image)
            xOffset+=screenWidth*0.01
        }
        self.view.addSubview(likedImageView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadMessages", name: "reloadMessages", object: nil)
        
        
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        // super.viewDidAppear(animated)
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadMessages", object: nil)
        
    }
    
    
    // LOAD MEssage -Dustin 8/11
    func loadMessages()
    {
        
        var lastMessage : JSQMessage?  = nil;
        
        if messages.last != nil
        {
            lastMessage = messages.last
        }
        
        
        let messageQuery = PFQuery(className:"Message")
        messageQuery.whereKey("room", equalTo: room)
        messageQuery.orderByAscending("updatedAt")
        
        messageQuery.limit = 1000
        messageQuery.includeKey("user")
        
        
        if lastMessage != nil
        {
            messageQuery.whereKey("createdAt", greaterThan: lastMessage!.date)
            
        }
        messageQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                let messages = results as! [PFObject]
                
                
                for message in messages
                {
                    self.messageObjects.append(message)
                    let user = message["user"] as! PFUser
                    self.users.append(user)
                    
                    let chatMessage = JSQMessage(senderId: user.objectId, senderDisplayName: user.username, date: message.createdAt, text: message["content"] as! String)
                    self.messages.append(chatMessage)
                }
                
                
                if results!.count != 0
                {
                    //self.finishReceivingMessage()
                    
                    self.finishReceivingMessageAnimated(true)
                }
            }
        }
        
        
        // Fix the bug when message is received while chatting. But unread indicator is still showing when moved to overview screen
        //  let sb = UIStoryboard(name: "Main", bundle: nil)
        // let messageVC = sb.instantiateViewControllerWithIdentifier("ChatOverView") as? OverViewController
        
        let user1 = PFUser.currentUser()!
        let user2 = incomingUser
        
        let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
        
        let roomQuery = PFQuery(className: "Room", predicate: pred)
        
        roomQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil
            {
                // let room = results!.last as! PFObject
                //     messageVC!.room = room
                // println("room is \(room)")
                //    messageVC?.incomingUser = user2
                
                let unreadQuery = PFQuery(className: "UnreadMessage")
                unreadQuery.whereKey("user", equalTo: PFUser.currentUser()!)
                unreadQuery.whereKey("room", equalTo: self.room)
                unreadQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                    if error == nil
                    {
                        if results!.count > 0{
                            let unreadMessages = results! as? [PFObject]
                            //    println(unreadMessges)
                            for msg in unreadMessages! {
                                msg.deleteInBackgroundWithBlock(nil)
                                
                            }
                            
                            
                        }
                        
                    }
                })
            }
        }
        
        
        
        
        
    }
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = PFObject(className: "Message")
        message["content"] = text;
        message["room"] = room
        message["user"] = PFUser.currentUser()!
        
        let currentUser = PFUser.currentUser()!
        let msgACL = PFACL()
        msgACL.setReadAccess(true, forRoleWithName: currentUser.objectId!)
        msgACL.setReadAccess(true, forRoleWithName: incomingUser.objectId!)
        msgACL.setWriteAccess(true, forRoleWithName: currentUser.objectId!)
        msgACL.setWriteAccess(true, forRoleWithName: incomingUser.objectId!)
        
        message.ACL = msgACL
        
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil
            {
                self.loadMessages()
                
                let pushQuery = PFInstallation.query()
                pushQuery?.whereKey("user", equalTo: self.incomingUser)
                
                let push = PFPush()
                push.setQuery(pushQuery)
                
                let pushDict = ["alert":text, "badge":"increment","sound":""]
                push.setData(pushDict)
                
                push.sendPushInBackgroundWithBlock(nil)
                
                
                self.room["lastUpdate"] = NSDate()
                self.room.saveInBackgroundWithBlock(nil)
                
                let unreadMsg = PFObject(className: "UnreadMessage")
                unreadMsg["user"] = self.incomingUser
                unreadMsg["room"] = self.room
                
                unreadMsg.saveInBackgroundWithBlock(nil)
                
                
            }
            else
            {
                
                print("Error sending msg\(error?.localizedDescription)")
                
            }
            
            self.finishSendingMessage()
        }
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == self.senderId
        {
            
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.row]
        if message.senderId == self.senderId
        {
            
            return selfAvartar
        }
        return incomingAvartar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if (indexPath.item) % 2 == 0
        {
            let message = messages[indexPath.row]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if (indexPath.item) % 2 == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId
        {
            
            cell.textView!.textColor = UIColor.blackColor()
        }
        else
        {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        //       let attributes  = [NSForegroundColorAttributeName:cell.textView!.textColor]
        
        //      cell.textView!.linkTextAttributes = attributes
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController.tabBarView.hidden = false
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateButton(xOffset: CGFloat, image:UIImage) {
        
        let WhatMyImageView : UIImageView = UIImageView()
        
        //  WhatMyImageView.frame  = CGRectMake(xOffset,screenHeight, xOffset+20, screenHeight*0.25)
        WhatMyImageView.frame = CGRectMake(xOffset, likedImageView.frame.height/1.7, likedImageView.frame.height/3,likedImageView.frame.height/3)
        WhatMyImageView.image = image
        WhatMyImageView.layer.cornerRadius = WhatMyImageView.frame.size.width/2
        
        WhatMyImageView.clipsToBounds = true
        //  WhatMyImageView.center  = CGPointMake(xOffset, (likedImageView.frame.height)/2)
        likedImageView.addSubview(WhatMyImageView)
        
    }
    
    /* for chatting window */

    
    func getWhatIinterested(index:Int)
    {
        
        whatIinterested.removeAll(keepCapacity: false)
        let query:PFQuery = PFQuery(className: "imageUpload")
        query.whereKey("user", equalTo: incomingUser)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error  == nil
            {
                for obj in objects!{
                    let thumbNail = obj["image"] as! PFFile
                    print("objects cpunt \(objects!.count)")
                    
                    thumbNail.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            self.whatIinterested.append(image!)
                            print("whatIinterested \(self.whatIinterested.count)")
                            
                            
                        }
                    })
                }
            }
                
            else
            {
                
                print("errror")
            }
            
        }
    }

    
    
    
}