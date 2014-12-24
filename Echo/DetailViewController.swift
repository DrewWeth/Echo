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
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    var detailItem: Post? {
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
//                let now = NSDate()
//                
//                let toArray = detail.created.componentsSeparatedByString(":")
//                let backToString = join("", toArray)
//                
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmssZZ"
//                let then = dateFormatter.dateFromString(detail.created) as NSDate!
//                println(then)
//                
//                let elapsedTime = NSDate().timeIntervalSinceDate(then)
//                label.text = String(NSInteger(elapsedTime))
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
        }
    }
    
    func addNew(post:NSDictionary)
    {
        println(post)
        
    }
    
    @IBAction func upvote(sender: AnyObject) {
        self.appDelegate.service.submitVote({
            (response) in
            self.addNew(response as NSDictionary)
            }, voteType: 1, postID: self.detailItem!.id)
        self.detailItem?.ups += 1
        
        
        
    }
    
    @IBAction func downvote(sender: AnyObject) {
        self.appDelegate.service.submitVote({
            (response) in
            self.addNew(response as NSDictionary)
            }, voteType: 2, postID: self.detailItem!.id)
        self.detailItem!.downs += 1
    
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

