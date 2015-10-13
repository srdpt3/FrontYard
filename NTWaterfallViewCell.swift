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

    var profileimageView : UIImageView  = UIImageView()
    var imageViewContent : UIImageView = UIImageView()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
        imageViewContent.addSubview(profileimageView)
        contentView.addSubview(imageViewContent)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        profileimageView.frame = CGRectMake(frame.width*0.05,frame.height*0.8, 30,30)
        profileimageView.center  = CGPointMake(self.imageViewContent.frame.width/6, (self.imageViewContent.frame.height)*0.9)
        profileimageView.layer.cornerRadius = profileimageView.frame.size.width/2
        profileimageView.clipsToBounds = true
        
        // self.profileimage.image = UIImage(data:data!)
        
     //   imageViewContent.image = UIImage(named: imageName!)
        imageViewContent.image = imageFile
     //   profileimageView.image = profileimageFile

    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}