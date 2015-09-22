//
//  ExampleOverlayView.swift
//  KolodaView
//
//  Created by Eugene Andreyev on 6/21/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like-1"
private let overlayLeftImageName = "overlay_skip-1"

class ExampleOverlayView: OverlayView {
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
       // var imageView = UIImageView(frame: self.bounds)
        
      var imageView = UIImageView(frame: CGRectMake(0, 50, 339, 382))

        imageView.autoresizingMask  = UIViewAutoresizing.FlexibleBottomMargin.union(UIViewAutoresizing.FlexibleHeight).union(UIViewAutoresizing.FlexibleRightMargin).union(UIViewAutoresizing.FlexibleLeftMargin).union(UIViewAutoresizing.FlexibleTopMargin ).union(UIViewAutoresizing.FlexibleWidth)
        
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit

        self.addSubview(imageView)
        
        return imageView
        }()

    override var overlayState:OverlayMode  {
        didSet {
            switch overlayState {
            case .Left :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }

}
