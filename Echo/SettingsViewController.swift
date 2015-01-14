//
//  SettingsViewController.swift
//  Echo
//
//  Created by AGW on 12/26/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var profileWidth:CGFloat = 100.0
    var profileHeight:CGFloat = 100.0
    var imageView :UIImageView!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var s3Url = "https://s3-us-west-2.amazonaws.com/echofoxtrot/"
    
    
    @IBOutlet weak var ChangeProfile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculations
        var screen = UIScreen.mainScreen().bounds
        var absoluteX = (screen.width / 2.0) - (profileWidth / 2.0)
        var absoluteY:CGFloat = 150.0
        
        
        var bgY:CGFloat = absoluteY + (profileHeight / 2.0)
        // Background picture
        var bgImage = UIImage(named: "background2.jpg")
        
        var bgImageBounds = UIImageView(frame:CGRectMake(0, 0, screen.width, bgY ))
        bgImageBounds.image = bgImage
        
        // Profile picture bounds
        self.imageView = UIImageView(frame: CGRectMake(absoluteX, absoluteY, profileWidth, profileHeight))
        imageView.image = appDelegate.device.profilePic
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.contentMode = .ScaleAspectFill
        
        if (self.appDelegate.device.data.count > 2 && !self.appDelegate.device.profilePicDownloaded){
            // Profile picture
            println("We have enough data to search for image")

            var url = NSURL(string: self.appDelegate.device.data[2] as String)

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
                println("Downloading image")
                var data = NSData(contentsOfURL: url!)
                println("Setting's profile picture is downloaded")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.device.profilePic = UIImage(data: data!)!
                    self.imageView.image = self.appDelegate.device.profilePic
                    self.appDelegate.device.profilePicDownloaded = true

                    println("Settings picture updated")
                })
            })
        }
        
//        var filePath = NSBundle.mainBundle().pathForResource("loading", ofType: "gif")
//        var gif = NSData(contentsOfFile: filePath!)
//        var webView = UIWebView(frame: CGRectMake(absoluteX, absoluteY, profileWidth, profileHeight))
//        webView.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
//        webView.userInteractionEnabled = false
//        webView.scalesPageToFit = true
        
        self.view.addSubview(bgImageBounds)
        self.imageView.image = appDelegate.device.profilePic
        self.view.addSubview(self.imageView)
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Picked an image")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("Picked!!")
        picker.dismissViewControllerAnimated(true, completion: nil)
        var uploadedImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.appDelegate.device.profilePic = uploadedImage
        self.imageView.image = self.appDelegate.device.profilePic
        imagePickerControllerDidCancel(picker)
        var tManager = AWSS3TransferManager.defaultS3TransferManager()
        

        // Prep image
        let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("temp"))
        let data = UIImagePNGRepresentation(uploadedImage)
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
                var profile_url = self.s3Url + image_identifier
                self.appDelegate.device.loadData(String(profile_url), position: 2)
                self.appDelegate.service.postProfileUrl({
                    (response) in
                    println(response)
                    }, device_id: self.appDelegate.device.data[0] as String, auth_key: self.appDelegate.device.data[1] as String, profile_url: profile_url)
            }
            return nil
        }
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("Imaging picking was canceled.")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeImage(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
