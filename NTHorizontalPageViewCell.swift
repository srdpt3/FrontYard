//
//  NTHorizontalPageViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/1/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit

let cellIdentify = "cellIdentify"

class NTTableViewCell : UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFontOfSize(13)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageView :UIImageView = self.imageView!;
        imageView.frame = CGRectZero
        imageView.backgroundColor = UIColor.whiteColor()
        if (imageView.image != nil) {
           // let imageHeight = imageView.image!.size.height*screenWidth/imageView.image!.size.width
            imageView.frame = CGRectMake(0, 0, screenWidth, screenHeight/2.5)
            
        imageView.autoresizingMask  = UIViewAutoresizing.FlexibleBottomMargin.union(UIViewAutoresizing.FlexibleHeight).union(UIViewAutoresizing.FlexibleRightMargin).union(UIViewAutoresizing.FlexibleLeftMargin).union(UIViewAutoresizing.FlexibleTopMargin ).union(UIViewAutoresizing.FlexibleWidth)
            
         //  imageView.contentMode = UIViewContentMode.ScaleAspectFit
          imageView.contentMode = UIViewContentMode.ScaleAspectFill
            
        }
    }
}

class NTHorizontalPageViewCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    var imageName : String?
        var imageFile : UIImage!
    var pullAction : ((offset : CGPoint) -> Void)?
    var tappedAction : (() -> Void)?
    
    
    
    
   // let tableView = UITableView(frame: screenBounds, style: UITableViewStyle.Plain)
    
    let tableView = UITableView(frame:CGRectMake(0, 0, screenWidth, screenHeight/2.5), style: UITableViewStyle.Plain)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(tableView)
        tableView.registerClass(NTTableViewCell.self, forCellReuseIdentifier: cellIdentify)
        tableView.delegate = self
        tableView.dataSource = self
        
        let backgroundView = UIView(frame:CGRectZero)
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = backgroundColor
        self.tableView.separatorColor = backgroundColor
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify) as! NTTableViewCell!
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        if indexPath.row == 0 {
            
            cell.imageView?.image = imageFile
            
            
        }
        
        cell.setNeedsLayout()
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cellHeight : CGFloat = navigationHeight
        if indexPath.row == 0{
            let image:UIImage! = UIImage(named: imageName!)
            let imageHeight = image.size.height*screenWidth/image.size.width
            cellHeight = imageHeight
        }
        return cellHeight
    }*/
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tappedAction?()

    }
    
    func scrollViewWillBeginDecelerating(scrollView : UIScrollView){
        if scrollView.contentOffset.y < navigationHeight{
            pullAction?(offset: scrollView.contentOffset)
        }
        //println("asdfasdf")
    }
}