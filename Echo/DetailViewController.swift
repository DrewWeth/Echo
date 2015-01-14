//
//  DetailViewController.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailCreatedLabel: UILabel!
    
    
    @IBOutlet weak var upsText: UILabel!
    @IBOutlet weak var viewsText: UILabel!
    @IBOutlet weak var downsText: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    
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
            if let label = self.contentLabel {
                label.text = detail.content
                label.sizeToFit()
                label.numberOfLines = 0
            }
            
            if let label = self.detailCreatedLabel {
                label.text = detail.created
            }
            
            if let text = self.upsText {
                text.text = String(detail.ups) + " ups"
            }
            if let text = self.downsText {
                text.text = String(detail.downs) + " downs"
            }
            if let text = self.viewsText {
                text.text = String(detail.views) + " views"
            }
            
            if let text = self.radiusLabel {
                text.text = String(format: "%.2f", detail.radius) as String
            }
            
            if let text = self.cityLabel {
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
            
            self.upsText.text = String(self.detailItem!.ups)
            self.downsText.text = String(self.detailItem!.downs)
            
            dispatch_async(dispatch_get_main_queue()){
                self.appDelegate.masterController.tableView.reloadData()
            }
        }
        
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
            
            self.upsText.text = String(self.detailItem!.ups)
            self.downsText.text = String(self.detailItem!.downs)

         
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

