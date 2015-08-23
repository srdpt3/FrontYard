//
//  photoUploadPageVC.swift
//  chatapp
//
//  Created by Dustin Yang on 12/14/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import CoreData

class photoUploadPageVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate{
    

    
    
    var fistImage  : PFFile!
    var progress: UInt8 = 0
    var picker = UIImagePickerController()
    var popover:UIPopoverController? = nil
    var buttonTag : Int = 0
    var imageFiles = [PFFile]()
    var fragenImages = [UIImage] ()
    
    @IBOutlet var DescTextView: UITextView! = UITextView()
    @IBOutlet var charRemainingLabel: UILabel! = UILabel()
 

    
    
    
    var buttonImage = [UIButton]()
   // let alert = SCLAlertView()
    @IBOutlet var image1: UIButton!
    @IBOutlet var image2: UIButton!
    @IBOutlet var image3: UIButton!
    @IBOutlet var image4: UIButton!
  //  let defaultimage : UIImage = UIImage(named: "upload.png")!
    let defaultbuttonImage = UIImage(named: "upload.png")


    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)

        
        
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
        
            println(DescTextView.text)
            
            PFUser.currentUser()!.save()
            
        
           // alert.addButton("Delete", target:self, selector:Selector("deleteButton"))
            
            var imageDBTable = PFObject(className: "imageUpload")
      //  var imagecount:Int =imageFiles.count

            imageDBTable["user"] = PFUser.currentUser()!.username
            imageDBTable["image"] = imageFiles[0]
            imageDBTable["description"] =  DescTextView.text
            for (i,image) in enumerate(imageFiles)
            {
                println("i is \(image)")
            // Create the post
                var myPost = PFObject(className:"Post")
                // Add a relation between the Post and Comment
                 myPost["obj_ptr"] = imageDBTable
                 myPost["images"] = image
                
                //  myPost.addUniqueObject(imageFile, forKey: "images")

                // PFUser.currentUser().addUniqueObject(usernames[currentUser], forKey:"following")
                myPost.saveInBackground()
        
                /*
                myPost.saveInBackgroundWithBlock {
                (success:Bool!, error:NSError!) -> Void in
                if success == true {
                    print("image upload completes")
                }
            }*/
        

                
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)

        
    }
    
    
    @IBOutlet var cancelPressed: UIButton!
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
        
        var alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: .Default) {
            UIAlertAction in
            self.openCamera(image)
        }
        
        var gallaryAction = UIAlertAction(title: "From Gallary", style: .Default) {
            UIAlertAction in
            self.openGallary(image)
        }
        var removeAction = UIAlertAction(title: "Delete Photo", style: .Default) {
            UIAlertAction in
            self.removePhoto(image)
        }
        var cacelAction = UIAlertAction(title: "Cancel", style: .Default) {
            UIAlertAction in
            
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(removeAction)
        alert.addAction(cacelAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(image.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Down  , animated: true)
        }
        
    }
    
    func openCamera(image:UIButton)
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = true
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            openGallary(image)
        }
        
    }
    func openGallary(image:UIButton)
    {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            picker.allowsEditing = true
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }

  
    }
    func removePhoto(image:UIButton)
    {
        if image.currentImage == UIImage(named: "upload.png")
        {
            println("It's default")
        }
        else
        {
            let defaultbuttonImage = UIImage(named: "upload.png")
            image.setImage(defaultbuttonImage, forState: UIControlState.Normal)
            
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
        
        
  //  let imageData = UIImagePNGRepresentation(image1.currentImage)
   // let imageFile = PFFile(name: "image.png", data: imageData)


    
   // self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
      println("picker Cancel")
       self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar:Int = 100 - newLength+1
            
            charRemainingLabel.text = "\(remainingChar)"
            
            return (newLength > 100) ? false : true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image1.setImage(defaultbuttonImage, forState: UIControlState.Normal)
        image2.setImage(defaultbuttonImage, forState: UIControlState.Normal)
        
        image3.setImage(defaultbuttonImage, forState: UIControlState.Normal)
        
        image4.setImage(defaultbuttonImage, forState: UIControlState.Normal)

//
       // let defaultbuttonImage = UIImage(named: "upload.png")
//image.setImage(defaultbuttonImage, forState: UIControlState.Normal)
        
        
        var nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
    //  self.transitioningDelegate = self.photoManager
        
        
        
        DescTextView.layer.borderColor = UIColor.blackColor().CGColor
        DescTextView.layer.borderWidth = 0.5
        DescTextView.layer.cornerRadius = 5
        DescTextView.delegate = self
        
        DescTextView.becomeFirstResponder()
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
    
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
     //   let defaultbuttonImage = defaultimage
         //       println(defaultbuttonImage)
        
      if (image1.currentImage == defaultbuttonImage)
      {
        
        println("asdfasdf")
        }

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }


}
