//
//  SignUpTableViewController.swift
//  Swapit
//
//  Created by Dustin Yang on 8/16/15.
//  Copyright (c) 2015 Dustin Yang. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var repeatPasswordTextField: UITextField!
    @IBOutlet var passwordTestField: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    var change = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationItem.rightBarButtonItem = doneBarButtonItem
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "icon_arrow_left.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 20, 20)
        btnName.addTarget(self, action: Selector("leftpressed"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftbutton:UIBarButtonItem = UIBarButtonItem()
        leftbutton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftbutton
        
        
        if change
        {
            let currentUser = PFUser.currentUser()!
            doneBarButtonItem.action = "changeProfile"
            
            
            username.text = PFUser.currentUser()?.username
            emailTextField.text = PFUser.currentUser()?.email
            username.enabled = false
            emailTextField.enabled = false
            
            
            firstnameTextField.text = currentUser["firstName"]as? String
            lastnameTextField.text = currentUser["lastName"] as? String
            
            passwordTestField.enabled = false
            repeatPasswordTextField.enabled = false
            
           if let profileImageFile = currentUser["profileImage"] as? PFFile
           {
                profileImageFile.getDataInBackgroundWithBlock({ (imagedata, error) -> Void in
                    if error == nil
                    {
                        self.profileImage.image = UIImage(data: imagedata!)
                        
                    }
                })
            
            
           }
            
         //   let
        }
        
    }
    func changeProfile()
    {
        let currentUser = PFUser.currentUser()!
        let profileImageData = UIImageJPEGRepresentation(profileImage.image!,0.6)
        let profileImagefile = PFFile(data: profileImageData!)
        
        if ( lastnameTextField.text != "" )
        {
            currentUser["firstName"] = firstnameTextField.text
        }
        if ( firstnameTextField.text != "")
        {
            currentUser["lastName"] = lastnameTextField.text
        }
        
         //   currentUser.username = username.text
          //  currentUser.email = emailTextField.text
        
            currentUser["profileImage"] = profileImagefile
            
            currentUser.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil{
                  
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                })
        
        /*
        else
        {
            
            
            let alert = UIAlertController(title: "Missing information", message: "Please fill out all items", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }*/
        
    }
    
    @IBAction func selectPictureButton(sender: AnyObject) {
        
        
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
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel  , handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageSize = image.size
        
        let width = imageSize.width
        let height = imageSize.height
        
        if width != height
        {
            let newDimension = min(width,height)
            let widthOffset = (width - newDimension)/2
            let heightOffset = (height - newDimension)/2
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), false, 0.0)
            image.drawAtPoint(CGPointMake(-widthOffset, -heightOffset))
            //   image.drawAtPoint(CGPointMake(-widthOffset, -heightOffset), blendMode: kCGBlendModeCopy, alpha: 1.0)
            
            image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
            
            
        }
        UIGraphicsBeginImageContext(CGSizeMake(150, 150))
        image.drawInRect(CGRectMake(0, 0, 150, 150))
        
        let small_Image = UIGraphicsGetImageFromCurrentImageContext()
        profileImage.image = small_Image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func completeSignUpButton(sender: AnyObject) {
        
        let profileImageData = UIImageJPEGRepresentation(profileImage.image!,0.6)
        let profileImagefile = PFFile(data: profileImageData!)
        
        if (username.text != "" && passwordTestField.text != "" && emailTextField.text != "" && repeatPasswordTextField.text != "")
       // if (username.text != "" && passwordTestField.text != "" && emailTextField.text != "" && lastnameTextField.text != "" &&
           // firstnameTextField.text != "" && repeatPasswordTextField.text != "")
        {
            
            let user = PFUser()
            user.username = username.text
            user.email = emailTextField.text
            print(passwordTestField.text)
            print(repeatPasswordTextField.text)

            if passwordTestField!.text == repeatPasswordTextField!.text{
                
                user.password = passwordTestField.text
                
                if ( lastnameTextField.text != "" )
                {
                    user["lastName"] = lastnameTextField.text
                }
                if ( firstnameTextField.text != "")
                {
                    user["firstName"] = firstnameTextField.text
                }
                
                user["profileImage"] = profileImagefile
                user["minPrice"] = 0
                user["maxPrice"] = 50000
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil
                    {
                        let roleACL = PFACL()
                        let role = PFRole(name: user.objectId!, acl: roleACL)
                        
                        role.users.addObject(user)
                        role.saveInBackgroundWithBlock(nil)
                        
                        
                        
                        let installation:PFInstallation = PFInstallation.currentInstallation()
                        installation["user"] = PFUser.currentUser()
                        installation.saveInBackgroundWithBlock(nil)
                        
                        self.showChatOverview()
                        
                    }
                })
                
                
                
            }else{
                let alert = UIAlertController(title: "Check your password again!", message: "Password does not match", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            

        }
        else
        {
            
            
            let alert = UIAlertController(title: "Missing information", message: "Please fill out all items", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        /*
        @IBOutlet var doneBarButtonItem: UIBarButtonItem!
        @IBOutlet var emailTextField: UITextField!
        @IBOutlet var lastnameTextField: UITextField!
        @IBOutlet var firstnameTextField: UITextField!
        @IBOutlet var repeatPasswordTextField: UITextField!
        @IBOutlet var passwordTestField: UITextField!
        
        */
    }
    func showChatOverview()
    {


      //  let alert = UIAlertController(title: "Thank You", message: "Link has been sent to your e-mail. Please verify it", preferredStyle: UIAlertControllerStyle.Alert)
     //   alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      //  self.presentViewController(alert, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "Thank you for signing up", message: "Please verify your e-mail", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
           // self.navigationController?.popViewControllerAnimated(true)
                print("ok")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)

   //     let sb = UIStoryboard(name: "Main", bundle: nil) g b g g
    //    let logginVC = sb.instantiateViewControllerWithIdentifier("mainViewController") as! mainViewController
        // self.navigationController?.pushViewController(logginVC, animated: true)
      //  self.parentViewController?.presentViewController(logginVC, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func leftpressed()
    {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}