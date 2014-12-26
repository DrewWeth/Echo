//
//  SubmitViewController.swift
//  Echo
//
//  Created by AGW on 12/25/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class SubmitViewController :UIViewController {
    
    
    @IBOutlet weak var inputText: UITextField!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    
    override func viewDidLoad() {
        var frameRect = inputText.frame;
        frameRect.size.width = self.view.frame.size.width
        println("Whats wrong?")
    
    }
    
    @IBAction func addName(sender: AnyObject) {
        println("Attempting to publish!!!")
        
        let textField = self.inputText
        
        if (textField.text != ""){
            
            
            // makes local copy -- just for nice-ity
            var postObj = Post(id: 0, content: textField.text, ups:0, downs:0, views:0, created:"2014-12-23T22:53:20.963Z")
            
            // Submits post to apii
            
            
            if (self.appDelegate.getLocationController().currentLocation != nil)
            {
                
                self.appDelegate.service.submitPost({
                    (response) in
                    self.addNew(response as NSDictionary)
                    }, content:textField.text, latitude: self.appDelegate.getLocationController().getCurrentLatitude(), longitude: self.appDelegate.getLocationController().getCurrentLongitude(), device_id: self.appDelegate.device.data[0] as String, auth_key: self.appDelegate.device.data[1] as String)
                
                
                self.appDelegate.masterController.postsCollection.insert(postObj, atIndex: 0)
                dispatch_async(dispatch_get_main_queue()){
                    self.appDelegate.masterController.tableView.reloadData()
                }
                
                
                navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
    }
    

    @IBAction func backSwipe(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    func addNew(post:NSDictionary)
    {
        println(post)
        
    }
}

