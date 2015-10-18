//
//  NTWaterfallViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

class NTWaterfallViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    var imageName : String?
    var imageFile:UIImage!
    var profileimageFile:UIImage!
    
    var imageLabel:UILabel! = UILabel()
    var imageLabel2:UILabel! = UILabel()

    var profileimageView : UIImageView  = UIImageView()
    var imageViewContent : UIImageView = UIImageView()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
      //  imageViewContent.addSubview(profileimageView)
       // contentView.addSubview(imageViewContent)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        /*
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        profileimageView.frame = CGRectMake(frame.width*0.05,frame.height*0.8, 30,30)
        profileimageView.center  = CGPointMake(self.imageViewContent.frame.width/6, (self.imageViewContent.frame.height)*0.9)
        profileimageView.layer.cornerRadius = profileimageView.frame.size.width/2
        profileimageView.clipsToBounds = true
        
        // self.profileimage.image = UIImage(data:data!)
        
     //   imageViewContent.image = UIImage(named: imageName!)
        imageViewContent.image = imageFile
     //   profileimageView.image = profileimageFile
*/
        
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-30)
        
        
        imageLabel.frame =  CGRectMake(0, frame.size.height-30, frame.size.width*0.6, 30)
        imageLabel2.frame =  CGRectMake(frame.size.width*0.59, frame.size.height-30, frame.size.width*0.42, 30)
        
        contentView.addSubview(imageViewContent)
        contentView.addSubview(imageLabel)
        contentView.addSubview(imageLabel2)
        
        
      //  imageLabel.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
       // imageLabel2.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        
        imageLabel.backgroundColor = UIColor.whiteColor()
        imageLabel2.backgroundColor =  UIColor.whiteColor()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10.0;
    //    contentView.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0).CGColor
        
        contentView.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        //   imageViewContent.image = UIImage(named: imageName!)
        imageViewContent.image = imageFile
        imageLabel.textColor = UIColor(red: 66/255, green:66/255, blue: 66/255, alpha: 1.0)
        
        
        // imageLabel.text = " teststest test tes testsetsetse testset setsetset"
        //  imageLabel2.text = "$150.0"
        imageLabel2.textAlignment = NSTextAlignment.Center;
        imageLabel2.textColor = UIColor(red: 156/255.0, green: 153/225.0, blue: 225/255.0, alpha: 1)
        imageLabel.font = imageLabel.font.fontWithSize(14)
        imageLabel2.font = imageLabel2.font.fontWithSize(14)
        
        
        
        

    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}