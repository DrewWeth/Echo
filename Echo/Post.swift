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
    public var profile_url:String
    public var image:UIImage!
    var defaultImage = UIImage(named:"background.jpg")
    public var hasDefaultImage:Bool
    
    init(id:Int, content:String, ups:Int, downs:Int, views:Int, created:String, profile_url:String){
        self.id = id
        self.content = content
        self.ups = ups
        self.downs = downs
        self.views = views
        self.created = created
        self.profile_url = profile_url
        self.hasDefaultImage = true
        
        self.image = defaultImage
        
        // Get new image, save it in post, and update cell if onscreen
        if (profile_url as NSString != "empty" && profile_url as NSString != ""){
            self.hasDefaultImage = false
            var url = NSURL(string: profile_url)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
                
                var data = NSData(contentsOfURL: url!)
                var image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.image = image
                    
                    self.image = image
                })
            })
        }
    }
    
    
    
    func toJSON() -> String{
        return ""
    }
}