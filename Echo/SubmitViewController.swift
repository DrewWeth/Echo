//
//  SubmitViewController.swift
//  Echo
//
//  Created by AGW on 12/25/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class SubmitViewController :UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var uploadedImage:UIImage!
    var userDidUpload:Bool!
    
    var s3Url = "https://s3-us-west-2.amazonaws.com/echofoxtrot/"

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var submitImage: UIImageView!
    
    override func viewDidLoad() {
        var frameRect = inputText.frame;
        frameRect.size.width = self.view.frame.size.width
        self.userDidUpload = false
        
    }
    
    @IBAction func addName(sender: AnyObject) {
        println("Attempting to publish!!!")
        
        let textField = self.inputText
        
        
        if (self.userDidUpload == true){
            
            // Submits post to apii
            if (self.userDidUpload == true){
                println("Input includes picture")
                self.uploadPicture(self.uploadedImage, content: textField.text)
                navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        else if (textField.text != "" ){ // only uploaded text
            println("Only input text")
            
            if (self.appDelegate.getLocationController().currentLocation != nil)
            {
                println("current loc not nil")
                self.appDelegate.service.submitPost({
                    (response) in
                    self.addNew(response as NSDictionary)
                    }, content:textField.text, latitude: self.appDelegate.getLocationController().getCurrentLatitude(), longitude: self.appDelegate.getLocationController().getCurrentLongitude(), device_id: self.appDelegate.device.data[0] as String, auth_key: self.appDelegate.device.data[1] as String)
                
            }
         
        }
        navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        println("Button pressed")
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, nil)
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("Imaging picking was canceled.")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("didFinishPickingImage")
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
    
        
        println("didFinishPickingMediaWithInfo")
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        self.uploadedImage = UIImage(CGImage: image.CGImage, scale: 1, orientation: image.imageOrientation)!
        
        self.submitImage.image = self.uploadedImage
        self.userDidUpload = true
        
        imagePickerControllerDidCancel(picker)
        
    }
    
    
    func uploadPicture(uploadImage:UIImage, content:String){
        var fixedImaged = UIImage(CGImage: uploadedImage.CGImage, scale: uploadedImage.scale, orientation: uploadedImage.imageOrientation)
        uploadedImage = fixedImaged
        
        var tManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        
        // Prep image
        let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("temp"))
        let data = UIImagePNGRepresentation(uploadImage)
        data.writeToURL(testFileURL1!, atomically: true)
        
        
        var uploadReq = AWSS3TransferManagerUploadRequest()
        uploadReq.bucket = "echofoxtrot"
        var unique = appDelegate.randomStringWithLength(8)
        var image_identifier = self.appDelegate.device.data[0] as String + "_" + unique + ".png"
        println("image_indentifier is \(image_identifier)")
        uploadReq.key = image_identifier
        uploadReq.body = testFileURL1
        
        uploadReq.contentType = "image/png"
        uploadReq.ACL = AWSS3ObjectCannedACL.PublicRead
        
        AWSS3TransferManager.defaultS3TransferManager().upload(uploadReq).continueWithBlock { (task) -> AnyObject! in
            if (task.error != nil) {
                if( task.error.code != AWSS3TransferManagerErrorType.Paused.hashValue
                    &&
                    task.error.code != AWSS3TransferManagerErrorType.Cancelled.hashValue
                    )
                {
                    //failed
                    println("failed")
                }
            } else {
                //completed
                println("completed")
                var postUrl = self.s3Url + image_identifier
                self.appDelegate.service.submitPost({
                    (response) in
                    self.addNew(response as NSDictionary)
                    }, content: content, latitude: self.appDelegate.getLocationController().getCurrentLatitude(), longitude: self.appDelegate.getLocationController().getCurrentLongitude(), device_id: self.appDelegate.device.data[0] as String, auth_key: self.appDelegate.device.data[1] as String, postUrl: postUrl)
                
            }
            return nil
        }
    }
    

    
    
    
    @IBAction func backSwipe(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    func addNew(post:NSDictionary)
    {
        println(post)
        //var postObj = Post(id: 0, content: "Hello", ups:0, downs:0, views:0, created:"2014-12-23T22:53:20.963Z", profileUrl:nil, address: "temp", city:"temp", radius:3902.0)
        //self.appDelegate.masterController.postsCollection.insert(postObj, atIndex: 0)
        
        
        dispatch_async(dispatch_get_main_queue()){
            self.appDelegate.masterController.tableView.reloadData()
        }
   
    }
}

