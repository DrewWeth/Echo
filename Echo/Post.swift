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
    
    init(id:Int, content:String, ups:Int, downs:Int, views:Int, created:String){
        self.id = id
        self.content = content
        self.ups = ups
        self.downs = downs
        self.views = views
        self.created = created
    }
    
    func toJSON() -> String{
        return ""
    }
}