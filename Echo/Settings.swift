//
//  Settings.swift
//  Echo
//
//  Created by AGW on 12/22/14.
//  Copyright (c) 2014 Andrew Wetherington. All rights reserved.
//

import Foundation

class Settings{
    var baseUrl:String = "http://104.236.81.195"
    
    var PostsURL = "/posts/nearby?"
    var PostsMethod = "get"
    
    var submitURL = "/posts/submit?"
    var submitMethod = "post"
    
    // Voting API 
    var upVoteURL = "/posts/up?"
    var downVoteURL = "/posts/down?"
    var voteMethod = "post"
    
    var registerURL = "/devices/register?"
    var registerMethod = "post"
    
    var updateProfileUrl = "/devices/newprofile?"
    
    init(){
    }
}
