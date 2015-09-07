//
//  photoUploadPageVC.swift
//  chatapp
//
//  Created by Dustin Yang on 12/14/14.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit
import CoreData


struct MoveKeyboard {
    static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
    static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
    static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
    static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
    static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
}

class photoUploadPageVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var image1:UIButton  = UIButton()
    var image2:UIButton  = UIButton()
    var image3:UIButton  = UIButton()
    var image4:UIButton  = UIButton()
    var itemTitleLabel : UILabel = UILabel()
    var itemTitleText: UITextField! = UITextField()
    var PriceLabel : UILabel = UILabel()
    var Currency: UITextField = UITextField()
    var Price: UITextField = UITextField()

    var pickerbutton:UITextView = UITextView()
    var uploadButton:UIButton  = UIButton()
    var DescLabel : UILabel = UILabel()
    var DescTextView: UITextView! = UITextView()
 
    
    
    var pickerData: [String] = [String]()

    var buttonTag : Int = 0
    var imageFiles = [PFFile]()
    var fragenImages = [UIImage] ()
    
    let defaultbuttonImage = UIImage(named: "Photo")
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    override func viewDidAppear(animated: Bool) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
       // appDelegate.tabBarController.tabBarView.hidden = true
    }

    override func viewDidLoad() {
            self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            let bounds = UIScreen.mainScreen().bounds
            var width = CGRectGetWidth(bounds)
    
            var height = CGRectGetHeight(bounds)
      //  DescTextView.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
     //   DescTextiew.contentVerticalAlignment  = scrollRangeToVisible:NSMakeRange(0, 1)
        DescTextView.contentInset = UIEdgeInsetsMake(0,0,0,0.0);
        DescTextView.sizeToFit()
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        pickerData = ["USD($)", "KRW(￦)", "EURO(€)"]
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                var textField = subview as! UITextField
                textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
                textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
                
            }
        }
        
            var buttonOffsetX = width*0.1
            var buttonOffsetY  = width/5
           // println(width)
            //println(height)
            
            self.navigationItem.hidesBackButton = false
            self.tabBarController?.tabBar.hidden = true
            var nav = self.navigationController?.navigationBar
            nav?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
            nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        
            var logoButton = UIButton(frame: CGRectMake(0 , 0, 98, 32))
            logoButton.setImage(UIImage(named: "main.gif"), forState: UIControlState.Normal)
            logoButton.setTitleColor(UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0), forState: UIControlState.Normal)
            self.navigationItem.titleView = logoButton
        

            
            
        // Image1 Button Frame
        image1.frame = CGRectMake(CGFloat(buttonOffsetX), CGFloat(buttonOffsetY), width*0.3, width*0.3)
        image1.tag = 1
        image1.setImage(UIImage(named: "Photo"), forState: .Normal)
        image1.addTarget(self, action: "image1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        image1.clipsToBounds = true
        image1.layer.cornerRadius = 0.0
        image1.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        image1.layer.borderWidth = 0.5;
        
        // Image2 Button Frame
        buttonOffsetX=width*0.6
        image2.frame = CGRectMake(CGFloat(buttonOffsetX), CGFloat(buttonOffsetY), width*0.3, width*0.3)
        image2.tag = 2
        image2.setImage(UIImage(named: "Photo"), forState: .Normal)
        image2.addTarget(self, action: "image2Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        image2.clipsToBounds = true
        image2.layer.cornerRadius = 0.0
        image2.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        image2.layer.borderWidth = 0.5

        buttonOffsetX = width*0.1
        buttonOffsetY+=width*0.3
        // Image3 Button Frame
        image3.frame = CGRectMake(CGFloat(buttonOffsetX), CGFloat(buttonOffsetY), width*0.3, width*0.3)
        image3.tag = 3

        image3.setImage(UIImage(named: "Photo"), forState: .Normal)
        image3.addTarget(self, action: "image3Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        image3.clipsToBounds = true
        image3.layer.cornerRadius = 0.0
        image3.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        image3.layer.borderWidth = 0.5;
        
        // Image4 Button Frame
         buttonOffsetX=width*0.6
        image4.frame = CGRectMake(CGFloat(buttonOffsetX), CGFloat(buttonOffsetY), width*0.3, width*0.3)
        image4.tag = 4
        image4.setImage(UIImage(named: "Photo"), forState: .Normal)
        image4.addTarget(self, action: "image4Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        image4.clipsToBounds = true
        image4.layer.cornerRadius = 0.0
        image4.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        image4.layer.borderWidth = 0.3;
 
        // Item Title Label
        
        buttonOffsetY+=width*0.3
        
        itemTitleLabel.frame = CGRectMake(width*0.01, buttonOffsetY, width, height/20)
        
        itemTitleLabel.text = "ITEM TITLE"
        itemTitleLabel.textAlignment = NSTextAlignment.Natural;
        itemTitleLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        itemTitleLabel.font = itemTitleLabel.font.fontWithSize(16)

        
        // Item Title Text
        buttonOffsetY+=(itemTitleLabel.frame.height)
        itemTitleText = UITextField(frame: CGRect(x: 0, y: buttonOffsetY, width: width, height: height/18));
        itemTitleText.backgroundColor = UIColor.whiteColor()
        itemTitleText.textAlignment = NSTextAlignment.Center;

        itemTitleText.layer.borderWidth = 0.2
        itemTitleText.layer.cornerRadius = 3
        itemTitleText.placeholder = " Item Name"

       // itemTitleText.sizeToFit()
        
        
        // Price  Label
        buttonOffsetY+=(itemTitleText.frame.height)
        
        PriceLabel.frame = CGRectMake(width*0.01, buttonOffsetY, width, height/25)
        PriceLabel.text = "PRICE"
        PriceLabel.textAlignment = NSTextAlignment.Natural;
        PriceLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        PriceLabel.font = PriceLabel.font.fontWithSize(16)
 

        buttonOffsetY+=(PriceLabel.frame.height)
       
        Currency = UITextField(frame: CGRect(x: 0, y: buttonOffsetY, width: width*0.2, height: height/18));
        Currency.text = "USD($)"
        Currency.font = UIFont(name: "Verdana", size: 16)
        Currency.backgroundColor = UIColor.whiteColor()
        Currency.textAlignment = .Center
        Currency.layer.borderColor = UIColor.grayColor().CGColor
        Currency.layer.borderWidth = 0.2
        Currency.layer.cornerRadius = 3
     //   Currency.inputView = pickerview2
   
        
        Price = UITextField(frame: CGRect(x: width*0.2, y: buttonOffsetY, width: width*0.8, height: height/18));
    //    Price.text = "0"
        // Price.sizeToFit()
        Price.font = UIFont(name: "Verdana", size: 16)
        Price.backgroundColor = UIColor.whiteColor()
        Price.textAlignment = .Center
        Price.layer.borderColor = UIColor.grayColor().CGColor
        Price.layer.borderWidth = 0.2
        Price.layer.cornerRadius = 3
        Price.textAlignment = NSTextAlignment.Center;
        Price.delegate = self
        Price.keyboardType = .NumberPad
        Price.placeholder = " Selling Price for item"
        
        
        buttonOffsetY+=(Price.frame.height)
        DescLabel.frame = CGRectMake(width*0.01, buttonOffsetY, width, height/25)

        DescLabel.text = "DESCRIPTION"
        DescLabel.textAlignment = NSTextAlignment.Natural;
        DescLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        DescLabel.font = itemTitleLabel.font.fontWithSize(16)
        
        
        buttonOffsetY+=(Price.frame.height)

        DescTextView = UITextView(frame: CGRect(x: 0, y: buttonOffsetY, width: width, height: height/6));
        self.view.addSubview(DescTextView)
        DescTextView.layer.borderColor = UIColor.grayColor().CGColor
        DescTextView.layer.borderWidth = 0.2
        DescTextView.layer.cornerRadius = 3

          DescTextView.becomeFirstResponder()
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(DescTextView)
        
        // upload Button Frame
        
        buttonOffsetY+=(DescTextView.frame.height)
        uploadButton.frame = CGRectMake(0, CGFloat(height-height/12), width, (height/12))
        uploadButton.setTitle(" Upload product", forState: UIControlState.Normal)
        uploadButton.titleLabel?.font = UIFont(name: "HevelticaNeue-UltraLight", size: 30.0)
        uploadButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uploadButton.backgroundColor = UIColor(red: 67.0/255.0, green: 179.0/255.0, blue: 229.0/255.0, alpha: 1)
        uploadButton.addTarget(self, action: "uploadPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        uploadButton.clipsToBounds = true
        uploadButton.layer.cornerRadius = 0.0
        uploadButton.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
        uploadButton.layer.borderWidth = 0.5;

        
        
        
        self.view.addSubview(image1)
        self.view.addSubview(image2)
        self.view.addSubview(image3)
        self.view.addSubview(image4)
        self.view.addSubview(itemTitleLabel)
        self.view.addSubview(itemTitleText)
        self.view.addSubview(PriceLabel)
        self.view.addSubview(Currency)
        self.view.addSubview(Price)
        self.view.addSubview(DescLabel)
        self.view.addSubview(DescTextView)
        self.view.addSubview(uploadButton)

        var pickerview2: UIPickerView = UIPickerView()
        pickerview2 = UIPickerView()
        pickerview2.delegate = self
        
        
        Currency.inputView = pickerview2

        


      //  Price.textContainer.lineFragmentPadding = 0;
      //  self.view.addSubview(uploadButton)
      //  self.view.addSubview(pickerbutton)
        
        /*
   

        
        // DescTextView.delegate = self
        buttonOffsetY+=(height/6)
   
        
        
        self.view.addSubview(image1)
        self.view.addSubview(image2)
        self.view.addSubview(image3)
        self.view.addSubview(image4)
        self.view.addSubview(uploadButton)
        self.view.addSubview(pickerbutton)
        
   //     image1.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    //    image1.addTarget(self, action: "image1pressed:", forControlEvents: UIControlEvents.TouchUpInside)
   //     image1.clipsToBounds = true
      //  image1.layer.cornerRadius = 0.0
   //     image1.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).CGColor
      ////  image1.layer.borderWidth = 0.5;

        */

    }
    @IBAction func image1Pressed(sender: AnyObject) {
        buttonTag = image1.tag
        
        alertDisplay(image1)
    }
    @IBAction func image2Pressed(sender: AnyObject) {
        buttonTag = image2.tag
        alertDisplay(image2)
    }
    @IBAction func image3Pressed(sender: AnyObject) {
        buttonTag = image3.tag
        alertDisplay(image3)
    }
    @IBAction func image4Pressed(sender: AnyObject) {
        buttonTag = image4.tag
        alertDisplay(image4)
    }

    
    
    func alertDisplay(image:UIButton)
    {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose the image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Take the Photo", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Reset to default", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
            if image.currentImage == UIImage(named: "Photo")
            {
                println("It's default")
            }
            else
            {
                let defaultbuttonImage = UIImage(named: "Photo")
                image.setImage(defaultbuttonImage, forState: UIControlState.Normal)
                
            }

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel  , handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadPressed(sender: AnyObject) {
        
        //let defaultbuttonImage = UIImage(named: "upload.png")
        
        if (image1.currentImage != defaultbuttonImage)
        {
            let imageData = UIImagePNGRepresentation(image1.imageView?.image)
            let imageFile = PFFile(name: "image.png", data: imageData)
            imageFiles.append(imageFile)
            
        }
        if (image2.currentImage != defaultbuttonImage)
        {
            let imageData2 = UIImagePNGRepresentation(image2.imageView?.image)
            let imageFile2 = PFFile(name: "image2.png", data: imageData2)
            imageFiles.append(imageFile2)
            
        }
        if (image3.currentImage != defaultbuttonImage)
        {
            let imageData3 = UIImagePNGRepresentation(image3.imageView?.image)
            let imageFile3 = PFFile(name: "image3.png", data: imageData3)
            imageFiles.append(imageFile3)
            
        }
        if (image4.currentImage != defaultbuttonImage)
        {
            let imageData4 = UIImagePNGRepresentation(image4.imageView?.image)
            let imageFile4 = PFFile(name: "image4.png", data: imageData4)
            imageFiles.append(imageFile4)
            
        }
        if (image1.currentImage == defaultbuttonImage &&
                image2.currentImage == defaultbuttonImage &&
                image3.currentImage == defaultbuttonImage &&
                image4.currentImage == defaultbuttonImage)
        {
                println("no pics selected")
        }
        else if (   itemTitleText.text == "" ||
                    DescTextView.text  == "" ||
                    Price.text  == ""   )
        {
                println("No item info")
        }
        else{
                PFUser.currentUser()!.save()
        
                var imageDBTable = PFObject(className: "imageUpload")
        
        imageDBTable["user"] = PFUser.currentUser()!
        imageDBTable["image"] = imageFiles[0]
        imageDBTable["description"] =  DescTextView.text
        imageDBTable["itemname"] =  DescTextView.text
        imageDBTable["price"] =  DescTextView.text
        for (i,image) in enumerate(imageFiles)
        {
            println("i is \(image)")
            // Create the post
            var myPost = PFObject(className:"Post")
            // Add a relation between the Post and Comment
            myPost["obj_ptr"] = imageDBTable
            myPost["images"] = image
            myPost.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success == true {
                    println("image upload completes")
                    self.image1.setImage(UIImage(named: "Photo"), forState: .Normal)
                    self.image2.setImage(UIImage(named: "Photo"), forState: .Normal)
                    self.image3.setImage(UIImage(named: "Photo"), forState: .Normal)
                    self.image4.setImage(UIImage(named: "Photo"), forState: .Normal)
                    self.Price.text = ""
                    self.itemTitleText.text = ""
                    self.DescTextView.text = ""

                  //  updateMyImage()
                }
                
            })
            //  myPost.addUniqueObject(imageFile, forKey: "images")
            
        }
        
                self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        println(buttonTag)
        
        switch buttonTag {
        case 1:
            image1.setImage(image, forState: UIControlState.Normal)
            
        case 2:
            image2.setImage(image, forState: UIControlState.Normal)
        case 3:
            image3.setImage(image, forState: UIControlState.Normal)
        case 4:
            image4.setImage(image, forState: UIControlState.Normal)
        default:
            println("no Button Tag")
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        println("picker Cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

    
    
    
  
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        
    }


    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.DescTextView.frame.origin.x, self.DescTextView.frame.origin.y + self.DescTextView.frame.size.height)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.DescTextView.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

            self.DescTextView.resignFirstResponder()
    }
    @IBAction func textFieldDidReturn(textField: UITextField!)
    {
        textField.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.DescTextView = textView
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Short Description of item"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
     
        if(row == 0)
        {
            self.Currency.text = "$"
        }
        else if(row == 1)
        {
            self.Currency.text = "￦"
        }
        else if(row == 2)
        {
            self.Currency.text = "€"
        }

    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
  
 
}
