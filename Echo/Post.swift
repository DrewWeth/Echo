//
//  Post.swift
//  Echo
//
//  Created by AGW on 12/21/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation

@objc(Post)    // add this line


public class Post{
    public var id: Int
    public var content:String
    public var ups:Int
    public var downs:Int
    public var views:Int
    public var created:String
    
    
    public var profilePic:UIImage!
    var defaultImage = UIImage(named:"background.jpg")
    public var hasDefaultImage:Bool 
    var city:String
    
    // Nullable values
    var profileUrl:String?
    var address:String?

    var constraint:Int?
    var postUrl:String?
    var postPic:UIImage?
    
    var radius:Float
    public var relevancy:Relevancy
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    init(id:Int, content:String, ups:Int, downs:Int, views:Int, created:String, profileUrl:String? = nil, address:String? = nil, city:String, radius:Float, constraint:Int? = nil, postUrl:String? = nil){
        self.id = id
        self.content = content
        self.ups = ups
        self.downs = downs
        self.views = views
        self.created = created
        self.profileUrl = profileUrl
        self.radius = radius
        self.hasDefaultImage = true
        self.profilePic = defaultImage
        
        self.profileUrl = profileUrl
        self.address = address
        self.city = city
        self.constraint = constraint
        self.postUrl = postUrl

        self.relevancy = Relevancy(postId: id)
        
        // Get new image, save it in post, and update cell if onscreen
        if (profileUrl != nil){
            self.hasDefaultImage = false
            var url = NSURL(string: profileUrl! as String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
                var error:NSError?

                var data = NSData(contentsOfURL: url!, options: nil, error:&error)
                if (error == nil){
                    var image = UIImage(data: data!)
                
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profilePic = image
                        //                    self.appDelegate.masterController.tableView.reloadData()
                    })
                }
            })
        }
        
        if (postUrl != nil){
            println("postUrl is not nil for \(self.content). The url is \(self.postUrl)")
            var url = NSURL(string: postUrl! as String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
                
                var error:NSError?
                var data = NSData(contentsOfURL: url!, options:nil, error: &error)

                if (error != nil){
                    println("error")

                }
                else{
                    var image = UIImage(data: data!)
                    self.postPic = image
                    println("image downloaded for \(self.content)")
                }
                
            })
        }
        
        
    }
    
    func toJSON() -> String{
        return ""
    }
    
    func addRelevancy(postId:Int, actionId:Int){
        var relevancy = Relevancy(postId: postId, actionId: actionId)
        self.relevancy = relevancy
    }
}



public class Relevancy {
    var postId:Int
    var actionId:Int
    
    init(postId:Int){
        self.postId = postId
        self.actionId = 0
    }
    
    init(postId:Int, actionId:Int){
        self.postId = postId
        self.actionId = actionId
    }
    
}