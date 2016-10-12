//
//  DetailViewController.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentdefine: UIdefine!
    @IBOutlet weak var detailCreateddefine: UIdefine!
    
    @IBOutlet weak var downsButton: UIButton!
    
    @IBOutlet weak var upsButton: UIButton!
    
    @IBOutlet weak var viewsText: UIdefine!
    
    @IBOutlet weak var citydefine: UIdefine!
    @IBOutlet weak var radiusdefine: UIdefine!
    
    @IBOutlet weak var postImage: UIImageView!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    var detailItem: Post! {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Post = self.detailItem {
            if let define = self.contentdefine {
                define.text = detail.content
                define.sizeToFit()
                define.numberOfLines = 0
            }
            
            if let define = self.detailCreateddefine {
                define.text = detail.created
            }
            
            if let text = self.upsButton {
                text.setTitle(String(detail.ups), forState: UIControlState.Normal)
            }
            if let text = self.downsButton {
                text.setTitle(String(detail.downs), forState: UIControlState.Normal)
            }
            if let text = self.viewsText {
                text.text = String(detail.views)
            }
            
            if let text = self.radiusdefine {
                text.text = String(format: "%.2f", detail.radius) as String
            }
            
            if let text = self.citydefine {
                text.text = String(detail.city)
            }
            
            if let image = self.postImage{
                if detail.postPic != nil{
                    image.image = detail.postPic
                }
                
            }
        }
    }
    
    func addNew(post:NSDictionary)
    {
        println(post)
    }
    
    
    @IBAction func unwindToMyController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func upvote(sender: AnyObject) {
        
        var post = self.detailItem!
        
        if (post.relevancy.actionId != 1){ // If not already upvoted
            if (post.relevancy.actionId == 2){ // If was already downvoted
                post.downs -= 1
            }
            post.relevancy.actionId = 1
            post.ups += 1
        
        
            self.appDelegate.service.submitVote({
                (response) in
                self.addNew(response as NSDictionary)
                }, voteType: 1, postID: self.detailItem!.id, deviceId: appDelegate.device.data[0] as String, authKey: appDelegate.device.data[1] as String)

            self.detailItem!.downs = post.downs
            self.detailItem!.ups = post.ups
            
            self.upsButton.setTitle(String(detailItem.ups), forState: UIControlState.Normal)
            self.downsButton.setTitle(String(detailItem.downs), forState: UIControlState.Normal)
            
            dispatch_async(dispatch_get_main_queue()){
                self.appDelegate.masterController.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func reportPost(sender: AnyObject) {
    }
    
    
    @IBAction func downvote(sender: AnyObject) {
        
        var post = self.detailItem!
        
        if (post.relevancy.actionId != 2){ // If not already downvoted
            if (post.relevancy.actionId == 1){ // If already upvoted
                post.ups -= 1
            }
            
            post.relevancy.actionId = 2
            post.downs += 1
            
            
            self.appDelegate.service.submitVote({
                (response) in
                self.addNew(response as NSDictionary)
                }, voteType: 2, postID: self.detailItem!.id, deviceId: appDelegate.device.data[0] as String, authKey: appDelegate.device.data[1] as String)

            self.detailItem!.downs = post.downs
            self.detailItem!.ups = post.ups
            
            
            
            self.upsButton.setTitle(String(detailItem.ups), forState: UIControlState.Normal)
            self.downsButton.setTitle(String(detailItem.downs), forState: UIControlState.Normal)
            
         
            dispatch_async(dispatch_get_main_queue()){
                self.appDelegate.masterController.tableView.reloadData()
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

